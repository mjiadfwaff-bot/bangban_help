// Package storager
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Ms <133814250@qq.com>
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package storager

import (
	"context"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/os/gfile"
	"github.com/gogf/gf/v2/os/gtime"
	"github.com/gogf/gf/v2/util/gconv"
	"io/fs"
	"os"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
)

const localUploadMaxBytes = int64(10 << 30)

// LocalDrive 本地驱动
type LocalDrive struct {
}

// Upload 上传到本地
func (d *LocalDrive) Upload(ctx context.Context, file *ghttp.UploadFile) (fullPath string, err error) {
	var (
		sp      = g.Cfg().MustGet(ctx, "server.serverRoot")
		nowDate = gtime.Date()
	)

	if sp.IsEmpty() {
		err = gerror.New("本地上传驱动必须配置静态路径!")
		return
	}

	if config.LocalPath == "" {
		err = gerror.New("本地上传驱动必须配置本地存储路径!")
		return
	}
	if err = ensureLocalUploadCapacity(ctx, file.Size); err != nil {
		return
	}

	// 包含静态文件夹的路径
	fullDirPath := strings.Trim(sp.String(), "/") + "/" + config.LocalPath + nowDate
	fileName, err := file.Save(fullDirPath, true)
	if err != nil {
		return
	}
	// 不含静态文件夹的路径
	fullPath = config.LocalPath + nowDate + "/" + fileName
	return
}

// CreateMultipart 创建分片事件
func (d *LocalDrive) CreateMultipart(ctx context.Context, in *CheckMultipartParams) (mp *MultipartProgress, err error) {
	if err = ensureLocalUploadCapacity(ctx, in.meta.Size); err != nil {
		return nil, err
	}
	mp = new(MultipartProgress)
	mp.UploadId = GenUploadId(ctx, in.Md5)
	mp.Meta = in.meta
	mp.ShardCount = in.ShardCount
	mp.UploadedIndex = make([]int, 0)
	mp.CreatedAt = gtime.Now()
	if err = CreateMultipartProgress(ctx, mp); err != nil {
		return nil, err
	}
	return
}

// UploadPart 上传分片
func (d *LocalDrive) UploadPart(ctx context.Context, in *UploadPartParams) (res *UploadPartModel, err error) {
	sp := g.Cfg().MustGet(ctx, "server.serverRoot")
	if sp.IsEmpty() {
		err = gerror.New("本地上传驱动必须配置静态路径!")
		return
	}

	spStr := strings.Trim(sp.String(), "/") + "/"

	if config.LocalPath == "" {
		err = gerror.New("本地上传驱动必须配置本地存储路径!")
		return
	}
	if err = ensureLocalUploadCapacity(ctx, in.File.Size); err != nil {
		return
	}

	// 分片文件存放路径
	partFilePath := spStr + config.LocalPath + "tmp/" + in.Md5

	// 写入文件
	in.File.Filename = gconv.String(in.Index)
	if _, err = in.File.Save(partFilePath, false); err != nil {
		return
	}

	// 更新上传进度
	in.mp.UploadedIndex = append(in.mp.UploadedIndex, in.Index)
	if err = UpdateMultipartProgress(ctx, in.mp); err != nil {
		return nil, err
	}

	res = new(UploadPartModel)

	// 已全部上传完毕
	if len(in.mp.UploadedIndex) == in.mp.ShardCount {
		if err = ensureLocalUploadCapacity(ctx, in.mp.Meta.Size); err != nil {
			return nil, err
		}
		// 删除进度统计
		if err = DelMultipartProgress(ctx, in.mp); err != nil {
			return nil, err
		}

		// 合并文件
		finalDirPath := GenFullPath(config.LocalPath, gfile.Ext(in.mp.Meta.Filename))
		if err = MergePartFile(partFilePath, spStr+finalDirPath); err != nil {
			err = gerror.Newf("合并分片文件出错:%v", err.Error())
			return nil, err
		}

		// 删除临时分片
		if err = os.RemoveAll(partFilePath); err != nil {
			err = gerror.Newf("删除临时分片文件出错:%v", err.Error())
			return nil, err
		}

		// 写入附件记录
		attachment, err := write(ctx, in.mp.Meta, finalDirPath)
		if err != nil {
			return nil, err
		}

		res.Finish = true
		res.Progress = 100
		res.Attachment = attachment
		return res, nil
	}

	// 计算上传进度
	res.Progress = CalcUploadProgress(in.mp.UploadedIndex, in.mp.ShardCount)
	return
}

func ensureLocalUploadCapacity(ctx context.Context, incoming int64) error {
	if incoming < 0 {
		incoming = 0
	}
	root, err := localUploadRoot(ctx)
	if err != nil {
		return err
	}
	used, err := localUploadUsedBytes(root)
	if err != nil {
		return gerror.Wrap(err, "统计本地上传目录容量失败")
	}
	if used+incoming > localUploadMaxBytes {
		return gerror.Newf("本地上传存储已超过限制，当前约 %.2fGB，最大 10GB，请清理附件或切换对象存储", float64(used)/1024/1024/1024)
	}
	return nil
}

func localUploadRoot(ctx context.Context) (string, error) {
	sp := g.Cfg().MustGet(ctx, "server.serverRoot")
	if sp.IsEmpty() {
		return "", gerror.New("本地上传驱动必须配置静态路径!")
	}
	if config.LocalPath == "" {
		return "", gerror.New("本地上传驱动必须配置本地存储路径!")
	}
	return strings.Trim(sp.String(), "/") + "/" + strings.Trim(config.LocalPath, "/"), nil
}

func localUploadUsedBytes(root string) (int64, error) {
	if !gfile.Exists(root) {
		return 0, nil
	}
	var total int64
	err := filepath.WalkDir(root, func(path string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return nil
		}
		info, err := d.Info()
		if err != nil {
			return nil
		}
		total += info.Size()
		return nil
	})
	return total, err
}

// MergePartFile 合并分片文件
func MergePartFile(srcPath, dstPath string) (err error) {
	dir, err := os.ReadDir(srcPath)
	if err != nil {
		return err
	}
	sort.Slice(dir, func(i, j int) bool {
		fiIndex, _ := strconv.Atoi(dir[i].Name())
		fjIndex, _ := strconv.Atoi(dir[j].Name())
		return fiIndex < fjIndex
	})
	for _, file := range dir {
		filePath := filepath.Join(srcPath, file.Name())
		if err = gfile.PutBytesAppend(dstPath, gfile.GetBytes(filePath)); err != nil {
			return err
		}
	}
	return
}

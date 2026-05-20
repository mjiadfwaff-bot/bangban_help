// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"encoding/json"
	"fmt"
	"path"
	"strconv"
	"strings"
	"time"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/net/ghttp"
	"github.com/gogf/gf/v2/text/gstr"
	"github.com/gogf/gf/v2/util/grand"
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/internal/dao"
	"hotgo/internal/library/storager"
	isysin "hotgo/internal/model/input/sysin"
	isc "hotgo/internal/service"
	"hotgo/utility/file"
)

const (
	noteTypeTitle    = "NOTE_TYPE_TITLE"
	noteTypeText     = "NOTE_TYPE_TEXT"
	noteTypeImage    = "NOTE_TYPE_IMAGE"
	noteTypeVideo    = "NOTE_TYPE_VIDEO"
	noteTypeLocation = "NOTE_TYPE_LOCATION"
)

type sourceMessage struct {
	Content        string          `json:"content"`
	ContentId      string          `json:"contentId"`
	Id             string          `json:"id"`
	PairId         string          `json:"pairId"`
	ReceiverRoomId string          `json:"receiverRoomId"`
	RoomName       string          `json:"roomName"`
	Sender         string          `json:"sender"`
	SenderDno      string          `json:"senderDno"`
	SenderUser     json.RawMessage `json:"senderUser"`
	Type           string          `json:"type"`
	UpId           string          `json:"upId"`
}

type noteContent struct {
	UpId       int64      `json:"upId"`
	Items      []noteItem `json:"items"`
	CreateTime int64      `json:"createTime"`
	UpdateTime int64      `json:"updateTime"`
	TopTime    int64      `json:"topTime"`
}

type noteItem struct {
	Type        string  `json:"type"`
	Title       string  `json:"title"`
	SubTitle    string  `json:"subTitle"`
	Content     string  `json:"content"`
	Duration    int     `json:"duration"`
	VerifyVideo bool    `json:"verifyVideo"`
	AspectRatio float64 `json:"aspectRatio"`
}

func (s *sLazySheepTGGo) storeNote(ctx context.Context, in *sysin.NoteStoreInp) (res *sysin.NoteStoreModel, err error) {
	if in == nil || strings.TrimSpace(in.Payload) == "" {
		return nil, gerror.New("笔记原始内容不能为空")
	}
	var msg sourceMessage
	if err = json.Unmarshal([]byte(in.Payload), &msg); err != nil {
		return nil, gerror.Wrap(err, "解析消息失败")
	}
	if msg.Type != "MESSAGE_TYPE_NOTES" {
		return nil, gerror.New("仅支持 MESSAGE_TYPE_NOTES 类型")
	}
	var note noteContent
	if err = json.Unmarshal([]byte(msg.Content), &note); err != nil {
		return nil, gerror.Wrap(err, "解析笔记内容失败")
	}

	title, text := noteText(note.Items)
	botID, err := s.resolveBotID(ctx, in.BotKey)
	if err != nil {
		return nil, err
	}
	bindingID, err := s.resolveBindingID(ctx, in.BindingKey)
	if err != nil {
		return nil, err
	}
	contentID := parseInt(msg.ContentId)
	code := genNoteCode(contentID, msg.Id)

	err = dao.AddonLazysheepTggoNote.Transaction(ctx, func(ctx context.Context, tx gdb.TX) error {
		noteID, err := s.upsertNoteRow(ctx, &noteStoreRow{
			BotID:          botID,
			BindingID:      bindingID,
			ContentID:      contentID,
			UpID:           note.UpId,
			PairID:         msg.PairId,
			ReceiverRoomID: parseInt(msg.ReceiverRoomId),
			RoomName:       msg.RoomName,
			Sender:         msg.Sender,
			SenderDno:      msg.SenderDno,
			SenderUser:     msg.SenderUser,
			RawPayload:     in.Payload,
			NotePayload:    msg.Content,
			Code:           code,
			Title:          title,
			TextContent:    text,
		})
		if err != nil {
			return err
		}
		if err = s.replaceNoteItems(ctx, noteID, note.Items); err != nil {
			return err
		}
		res = &sysin.NoteStoreModel{NoteId: noteID, Code: code}
		return nil
	})
	return
}

type noteStoreRow struct {
	BotID          int
	BindingID      int
	ContentID      int64
	UpID           int64
	PairID         string
	ReceiverRoomID int64
	RoomName       string
	Sender         string
	SenderDno      string
	SenderUser     json.RawMessage
	RawPayload     string
	NotePayload    string
	Code           string
	Title          string
	TextContent    string
}

func (s *sLazySheepTGGo) upsertNoteRow(ctx context.Context, row *noteStoreRow) (int64, error) {
	cols := dao.AddonLazysheepTggoNote.Columns()
	data := g.Map{
		cols.BotId:          row.BotID,
		cols.BindingId:      row.BindingID,
		cols.ContentId:      row.ContentID,
		cols.UpId:           row.UpID,
		cols.PairId:         row.PairID,
		cols.ReceiverRoomId: row.ReceiverRoomID,
		cols.RoomName:       row.RoomName,
		cols.Sender:         row.Sender,
		cols.SenderDno:      row.SenderDno,
		cols.SenderUser:     gjson.New(row.SenderUser),
		cols.RawPayload:     gjson.New(row.RawPayload),
		cols.NotePayload:    gjson.New(row.NotePayload),
		cols.MessageType:    "MESSAGE_TYPE_NOTES",
		cols.Code:           row.Code,
		cols.Title:          row.Title,
		cols.TextContent:    row.TextContent,
		cols.WorkflowStatus: 1,
		cols.Status:         1,
	}
	return upsertByKey(ctx, dao.AddonLazysheepTggoNote.Ctx(ctx), cols.ContentId, row.ContentID, data)
}

func (s *sLazySheepTGGo) replaceNoteItems(ctx context.Context, noteID int64, items []noteItem) error {
	cols := dao.AddonLazysheepTggoNoteItem.Columns()
	if _, err := dao.AddonLazysheepTggoNoteItem.Ctx(ctx).Where(cols.NoteId, noteID).Delete(); err != nil {
		return gerror.Wrap(err, "清理旧笔记项失败")
	}
	for index, item := range items {
		row := g.Map{
			cols.NoteId:      noteID,
			cols.ItemIndex:   index,
			cols.ItemType:    item.Type,
			cols.Title:       item.Title,
			cols.SubTitle:    item.SubTitle,
			cols.Content:     item.Content,
			cols.Duration:    item.Duration,
			cols.AspectRatio: item.AspectRatio,
			cols.VerifyVideo: boolToInt(item.VerifyVideo),
			cols.Status:      1,
		}
		if isRemoteMedia(item.Type) {
			attachment, err := transferRemoteMedia(ctx, item.Type, item.Content)
			if err != nil {
				g.Log().Warningf(ctx, "转存媒体失败 noteId:%d url:%s err:%+v", noteID, item.Content, err)
			} else if attachment != nil {
				row[cols.AttachmentId] = attachment.Id
				row[cols.PreviewUrl] = attachment.FileUrl
				row[cols.LocalPath] = attachment.Path
			}
		}
		if _, err := dao.AddonLazysheepTggoNoteItem.Ctx(ctx).Data(row).Insert(); err != nil {
			return gerror.Wrap(err, "保存笔记项失败")
		}
	}
	return nil
}

func (s *sLazySheepTGGo) StoreNote(ctx context.Context, in *sysin.NoteStoreInp) (res *sysin.NoteStoreModel, err error) {
	return s.storeNote(ctx, in)
}

func (s *sLazySheepTGGo) resolveBindingID(ctx context.Context, bindingKey string) (int, error) {
	if strings.TrimSpace(bindingKey) == "" {
		return 0, nil
	}
	cols := dao.AddonLazysheepTggoBinding.Columns()
	val, err := dao.AddonLazysheepTggoBinding.Ctx(ctx).Fields(cols.Id).Where(cols.BindingKey, bindingKey).Value()
	if err != nil {
		return 0, gerror.Wrap(err, "查询绑定失败")
	}
	if val.IsNil() {
		return 0, gerror.Newf("绑定不存在：%s", bindingKey)
	}
	return val.Int(), nil
}

func transferRemoteMedia(ctx context.Context, itemType, rawURL string) (*isysin.AttachmentListModel, error) {
	if !gstr.HasPrefix(rawURL, "http://") && !gstr.HasPrefix(rawURL, "https://") {
		return nil, gerror.New("仅支持 HTTP/HTTPS 媒体链接")
	}
	resp, err := g.Client().SetTimeout(time.Second * 60).Get(ctx, rawURL)
	if err != nil {
		return nil, err
	}
	defer resp.Close()
	if resp.StatusCode != 200 {
		return nil, gerror.Newf("请求媒体失败, StatusCode:%v", resp.StatusCode)
	}
	content := resp.ReadAll()
	if len(content) == 0 {
		return nil, gerror.New("媒体内容为空")
	}
	kind, ext := mediaKindAndExt(itemType, rawURL, resp.Header.Get("Content-Type"))
	fileHeader, err := file.NewMultipartFileHeader("lazy-"+grand.Letters(8)+ext, content)
	if err != nil {
		return nil, gerror.Newf("创建文件头失败：%v", err)
	}
	return isc.CommonUpload().UploadFile(ctx, kind, &ghttp.UploadFile{FileHeader: fileHeader})
}

func mediaKindAndExt(itemType, rawURL, contentType string) (string, string) {
	urlExt := strings.ToLower(path.Ext(strings.Split(rawURL, "?")[0]))
	if urlExt == "" {
		if strings.Contains(contentType, "video/") {
			urlExt = ".mp4"
		} else {
			urlExt = ".jpg"
		}
	}
	if itemType == noteTypeVideo {
		return storager.KindVideo, urlExt
	}
	return storager.KindImg, urlExt
}

func noteText(items []noteItem) (title string, text string) {
	var parts []string
	for _, item := range items {
		switch item.Type {
		case noteTypeTitle:
			if title == "" {
				title = item.Content
			}
		case noteTypeText:
			if strings.TrimSpace(item.Content) != "" {
				parts = append(parts, item.Content)
			}
		}
	}
	return title, strings.Join(parts, "\n")
}

func parseInt(v string) int64 {
	n, _ := strconv.ParseInt(strings.TrimSpace(v), 10, 64)
	return n
}

func genNoteCode(contentID int64, fallback string) string {
	raw := contentID
	if raw <= 0 {
		raw = parseInt(fallback)
	}
	if raw < 0 {
		raw = -raw
	}
	return fmt.Sprintf("LS%06d", raw%1000000)
}

func isRemoteMedia(itemType string) bool {
	return itemType == noteTypeImage || itemType == noteTypeVideo
}

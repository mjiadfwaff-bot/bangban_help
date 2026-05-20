// Package config
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package config

import (
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
)

type GetReq struct {
	g.Meta `path:"/config/get" method:"get" tags:"懒羊羊TGGo" summary:"获取配置"`
	sysin.GetConfigInp
}

type GetRes struct {
	*sysin.GetConfigModel
}

type UpdateReq struct {
	g.Meta `path:"/config/update" method:"post" tags:"懒羊羊TGGo" summary:"更新配置"`
	sysin.UpdateConfigInp
}

type UpdateRes struct{}

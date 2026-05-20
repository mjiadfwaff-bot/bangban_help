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

type InspectBotReq struct {
	g.Meta `path:"/config/inspectBot" method:"post" tags:"懒羊羊TGGo" summary:"检测机器人"`
	sysin.BotInspectInp
}

type InspectBotRes struct {
	*sysin.BotInspectModel
}

type DeleteBotReq struct {
	g.Meta `path:"/config/deleteBot" method:"post" tags:"懒羊羊TGGo" summary:"删除机器人"`
	sysin.BotDeleteInp
}

type DeleteBotRes struct{}

type StartBotReq struct {
	g.Meta `path:"/config/startBot" method:"post" tags:"懒羊羊TGGo" summary:"启动机器人"`
	sysin.BotStartInp
}

type StartBotRes struct{}

type BotUsersReq struct {
	g.Meta `path:"/config/botUsers" method:"get" tags:"懒羊羊TGGo" summary:"机器人用户列表"`
	sysin.BotUserListInp
}

type BotUsersRes struct {
	List []*sysin.BotUserListModel `json:"list"`
}

type UpdateBotUserReq struct {
	g.Meta `path:"/config/updateBotUser" method:"post" tags:"懒羊羊TGGo" summary:"更新机器人用户"`
	sysin.BotUserEditInp
}

type UpdateBotUserRes struct{}

type TestTelegramProxyReq struct {
	g.Meta `path:"/config/testTelegramProxy" method:"post" tags:"懒羊羊TGGo" summary:"检测Telegram代理"`
	sysin.TelegramProxyTestInp
}

type TestTelegramProxyRes struct {
	*sysin.TelegramProxyTestModel
}

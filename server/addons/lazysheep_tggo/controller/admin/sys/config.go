// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"hotgo/addons/lazysheep_tggo/api/admin/config"
	"hotgo/addons/lazysheep_tggo/service"
)

var Config = cConfig{}

type cConfig struct{}

func (c *cConfig) GetConfig(ctx context.Context, req *config.GetReq) (res *config.GetRes, err error) {
	data, err := service.SysLazysheepTggo().GetState(ctx)
	if err != nil {
		return
	}
	res = &config.GetRes{GetConfigModel: req.GetConfigInp.ToModel(data)}
	return
}

func (c *cConfig) UpdateConfig(ctx context.Context, req *config.UpdateReq) (res *config.UpdateRes, err error) {
	err = service.SysLazysheepTggo().SaveState(ctx, req.UpdateConfigInp.ToState())
	if err != nil {
		return
	}
	res = new(config.UpdateRes)
	return
}

// ====================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// ====================================================================

package service

import (
	"context"
	"hotgo/addons/lazysheep_tggo/model"
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
)

type (
	ILazySheepTGGo interface {
		Install(ctx context.Context) error
		Upgrade(ctx context.Context) error
		UnInstall(ctx context.Context) error

		GetState(ctx context.Context) (res *model.State, err error)
		SaveState(ctx context.Context, state *model.State) error
		TouchUser(ctx context.Context, in *sysin.TouchUserInp) error
		UpsertBot(ctx context.Context, in *sysin.BotUpsertInp) (key string, err error)
		BindSource(ctx context.Context, in *sysin.BindSourceInp) error
		PullNow(ctx context.Context, in *sysin.PullInp) (message string, err error)
		SignIn(ctx context.Context, in *sysin.SignInInp) (message string, err error)

		GetRuntime(ctx context.Context, botKey string) (rt *model.Runtime, err error)
		SyncBot(ctx context.Context, botKey string) error
		SyncAllBots(ctx context.Context) error
		HandleWebhook(ctx context.Context, botKey string, payload []byte) error
		SetWebhook(ctx context.Context, botKey, webhookURL string) error
	}
)

var localLazySheepTGGo ILazySheepTGGo

func SysLazysheepTggo() ILazySheepTGGo {
	if localLazySheepTGGo == nil {
		panic("implement not found for interface ILazySheepTGGo, forgot register?")
	}
	return localLazySheepTGGo
}

func RegisterSysLazysheepTggo(i ILazySheepTGGo) {
	localLazySheepTGGo = i
}

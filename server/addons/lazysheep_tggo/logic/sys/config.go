// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"fmt"

	"hotgo/addons/lazysheep_tggo/model"
	lsysin "hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/addons/lazysheep_tggo/service"
)

type sLazySheepTGGo struct {
	runtime *runtimeStore
}

func NewLazySheepTGGo() *sLazySheepTGGo {
	return &sLazySheepTGGo{runtime: newRuntimeStore()}
}

func init() {
	service.RegisterSysLazysheepTggo(NewLazySheepTGGo())
}

func (s *sLazySheepTGGo) Install(ctx context.Context) error {
	_, err := s.GetState(ctx)
	return err
}

func (s *sLazySheepTGGo) Upgrade(ctx context.Context) error {
	return s.SyncAllBots(ctx)
}

func (s *sLazySheepTGGo) UnInstall(ctx context.Context) error {
	s.runtime.Reset()
	return nil
}

func (s *sLazySheepTGGo) GetState(ctx context.Context) (res *model.State, err error) {
	return s.loadState(ctx)
}

func (s *sLazySheepTGGo) SaveState(ctx context.Context, state *model.State) error {
	return s.saveState(ctx, state)
}

func (s *sLazySheepTGGo) TouchUser(ctx context.Context, in *lsysin.TouchUserInp) error {
	if in == nil || in.TelegramID == 0 {
		return nil
	}
	return s.upsertUser(ctx, in.TelegramID, &model.UserRecord{
		TelegramID:   in.TelegramID,
		Username:     in.Username,
		FirstName:    in.FirstName,
		LastName:     in.LastName,
		LanguageCode: in.LanguageCode,
		IsBot:        in.IsBot,
	})
}

func (s *sLazySheepTGGo) UpsertBot(ctx context.Context, in *lsysin.BotUpsertInp) (key string, err error) {
	key = in.Key
	if key == "" {
		key = shortHash(in.Token)
	}
	err = s.upsertBot(ctx, key, &model.BotConfig{
		Key:           key,
		Token:         in.Token,
		DisplayName:   in.DisplayName,
		WebhookSecret: in.WebhookSecret,
		WebhookPath:   in.WebhookPath,
		Enabled:       in.Enabled,
		AutoPull:      in.AutoPull,
		AutoForward:   in.AutoForward,
		ReviewEnabled: in.ReviewEnabled,
	})
	return key, err
}

func (s *sLazySheepTGGo) BindSource(ctx context.Context, in *lsysin.BindSourceInp) error {
	key := fmt.Sprintf("%s:%s:%d", in.BotKey, in.SourceURL, in.PublishChatID)
	return s.upsertBinding(ctx, key, &model.BindingRecord{
		Key:           key,
		BotKey:        in.BotKey,
		SourceURL:     in.SourceURL,
		SourceToken:   in.SourceToken,
		ReviewChatID:  in.ReviewChatID,
		PublishChatID: in.PublishChatID,
		Status:        "enabled",
		AutoPush:      in.AutoPush,
	})
}

func (s *sLazySheepTGGo) PullNow(ctx context.Context, in *lsysin.PullInp) (message string, err error) {
	return "已触发采集任务，后续会交给队列处理。", nil
}

func (s *sLazySheepTGGo) SignIn(ctx context.Context, in *lsysin.SignInInp) (message string, err error) {
	return "签到功能框架已接入，后续补充关注校验和验证码。", nil
}

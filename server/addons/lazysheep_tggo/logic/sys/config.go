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

	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/logic/bangchat"
	"hotgo/addons/lazysheep_tggo/model"
	lsysin "hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/addons/lazysheep_tggo/service"
	"hotgo/internal/dao"
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
	if err := s.ensureTables(ctx); err != nil {
		return err
	}
	_, err := s.GetState(ctx)
	return err
}

func (s *sLazySheepTGGo) Upgrade(ctx context.Context) error {
	if err := s.ensureTables(ctx); err != nil {
		return err
	}
	return s.SyncAllBots(ctx)
}

func (s *sLazySheepTGGo) UnInstall(ctx context.Context) error {
	s.runtime.Reset()
	return nil
}

func (s *sLazySheepTGGo) BootBots(ctx context.Context) error {
	return s.bootBots(ctx)
}

func (s *sLazySheepTGGo) GetState(ctx context.Context) (res *model.State, err error) {
	return s.loadState(ctx)
}

func (s *sLazySheepTGGo) SaveState(ctx context.Context, state *model.State) error {
	return s.saveState(ctx, state)
}

func (s *sLazySheepTGGo) SaveConfig(ctx context.Context, in *lsysin.UpdateConfigInp) error {
	if in == nil {
		return gerror.New("配置参数不能为空")
	}
	state := in.ToState()
	switch in.Group {
	case "plugins":
		return s.savePluginConfig(ctx, state)
	default:
		return s.saveState(ctx, state)
	}
}

func (s *sLazySheepTGGo) InspectBot(ctx context.Context, in *lsysin.BotInspectInp) (*lsysin.BotInspectModel, error) {
	return s.inspectBot(ctx, in)
}

func (s *sLazySheepTGGo) DeleteBot(ctx context.Context, in *lsysin.BotDeleteInp) error {
	return s.deleteBot(ctx, in)
}

func (s *sLazySheepTGGo) StartBot(ctx context.Context, in *lsysin.BotStartInp) error {
	if in == nil || in.Key == "" {
		return gerror.New("机器人标识不能为空")
	}
	return s.SyncBot(ctx, in.Key)
}

func (s *sLazySheepTGGo) BotUsers(ctx context.Context, in *lsysin.BotUserListInp) ([]*lsysin.BotUserListModel, error) {
	return s.botUsers(ctx, in)
}

func (s *sLazySheepTGGo) UpdateBotUser(ctx context.Context, in *lsysin.BotUserEditInp) error {
	return s.updateBotUser(ctx, in)
}

func (s *sLazySheepTGGo) TouchUser(ctx context.Context, in *lsysin.TouchUserInp) error {
	if in == nil || in.TelegramID == 0 {
		return nil
	}
	if err := s.ensureUserBotKey(ctx); err != nil {
		return err
	}
	return s.upsertUser(ctx, in.TelegramID, &model.UserRecord{
		TelegramID:   in.TelegramID,
		BotKey:       in.BotKey,
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
		Enabled:       in.Enabled,
		AutoPull:      in.AutoPull,
		AutoForward:   in.AutoForward,
		ReviewEnabled: in.ReviewEnabled,
	}, nil)
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
	if in == nil || in.BotKey == "" {
		return "", gerror.New("botKey 不能为空")
	}
	binding, err := s.findBinding(ctx, in.BotKey, in.SourceURL)
	if err != nil {
		return "", err
	}
	if binding == nil {
		return "", gerror.New("未找到可触发的绑定关系")
	}
	result, err := bangchat.Pull(ctx, bangchat.PullOption{URL: binding.SourceURL, Limit: 50, MaxPages: 0})
	if err != nil {
		return "", gerror.Wrap(err, "采集 BangChat 消息失败")
	}
	summary := &pullSummary{Fetched: len(result.Messages), PairID: result.PairID}
	for _, raw := range result.Messages {
		if !isBangchatNote(raw) {
			summary.Skipped++
			continue
		}
		if _, err = s.StoreNote(ctx, &lsysin.NoteStoreInp{
			BotKey:     in.BotKey,
			BindingKey: binding.Key,
			Payload:    string(raw),
		}); err != nil {
			summary.Failed++
			g.Log().Warningf(ctx, "保存 BangChat 笔记失败 botKey:%s binding:%s err:%+v", in.BotKey, binding.Key, err)
			continue
		}
		summary.Stored++
	}
	return summary.Message(), nil
}

type pullSummary struct {
	PairID  string
	Fetched int
	Stored  int
	Skipped int
	Failed  int
}

func (s *pullSummary) Message() string {
	return fmt.Sprintf("采集完成：获取 %d 条，入库 %d 条，跳过 %d 条，失败 %d 条。", s.Fetched, s.Stored, s.Skipped, s.Failed)
}

func isBangchatNote(raw json.RawMessage) bool {
	var msg struct {
		Type string `json:"type"`
	}
	_ = json.Unmarshal(raw, &msg)
	return msg.Type == "MESSAGE_TYPE_NOTES"
}

func (s *sLazySheepTGGo) SignIn(ctx context.Context, in *lsysin.SignInInp) (message string, err error) {
	return "签到功能框架已接入，后续补充关注校验和验证码。", nil
}

func (s *sLazySheepTGGo) findBinding(ctx context.Context, botKey, sourceURL string) (*model.BindingRecord, error) {
	state, err := s.GetState(ctx)
	if err != nil {
		return nil, err
	}
	for _, v := range state.Bindings {
		if v == nil {
			continue
		}
		if v.BotKey != botKey {
			continue
		}
		if sourceURL != "" && v.SourceURL != sourceURL {
			continue
		}
		return v, nil
	}
	cols := dao.AddonLazysheepTggoBinding.Columns()
	var row struct {
		SourceUrl string `json:"sourceUrl"`
	}
	mod := dao.AddonLazysheepTggoBinding.Ctx(ctx).Fields(cols.SourceUrl).Where(cols.BotKey, botKey)
	if sourceURL != "" {
		mod = mod.Where(cols.SourceUrl, sourceURL)
	}
	if err = mod.Scan(&row); err != nil {
		return nil, err
	}
	if row.SourceUrl == "" {
		return nil, nil
	}
	return &model.BindingRecord{
		BotKey:    botKey,
		SourceURL: row.SourceUrl,
	}, nil
}

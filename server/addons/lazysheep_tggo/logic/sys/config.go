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
	"strings"

	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/logic/bangchat"
	"hotgo/addons/lazysheep_tggo/model"
	lsysin "hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/addons/lazysheep_tggo/service"
	"hotgo/internal/dao"
	"hotgo/internal/library/hgrds/lock"
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

func (s *sLazySheepTGGo) IsBotAdmin(ctx context.Context, botKey string, telegramID int64) (bool, error) {
	if strings.TrimSpace(botKey) == "" || telegramID == 0 {
		return false, nil
	}
	cols := dao.AddonLazysheepTggoUser.Columns()
	val, err := dao.AddonLazysheepTggoUser.Ctx(ctx).
		Fields(cols.MemberLevel).
		Where("bot_key", botKey).
		Where(cols.TelegramId, telegramID).
		Value()
	if err != nil {
		return false, gerror.Wrap(err, "查询机器人管理员失败")
	}
	return !val.IsNil() && val.Int() >= 9, nil
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
	if in == nil || strings.TrimSpace(in.BotKey) == "" {
		return gerror.New("botKey 不能为空")
	}
	sourceURL := strings.TrimSpace(in.SourceURL)
	if sourceURL == "" {
		return gerror.New("BangChat 链接不能为空")
	}
	mode := strings.TrimSpace(in.Mode)
	if mode == "" {
		mode = "quick"
	}
	reviewChatID := in.ReviewChatID
	publishChatID := in.PublishChatID
	autoPush := in.AutoPush
	if in.ChatID != 0 {
		if mode == "review" {
			reviewChatID = in.ChatID
			autoPush = false
		} else {
			publishChatID = in.ChatID
			autoPush = true
		}
	}
	key := fmt.Sprintf("%s:%s", in.BotKey, sourceURL)
	return s.upsertBinding(ctx, key, &model.BindingRecord{
		Key:             key,
		BotKey:          in.BotKey,
		SourceURL:       sourceURL,
		SourceToken:     in.SourceToken,
		ReviewChatID:    reviewChatID,
		PublishChatID:   publishChatID,
		Status:          "enabled",
		AutoPush:        autoPush,
		VerifyEnabled:   true,
		LocationEnabled: true,
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
	pullKey := fmt.Sprintf("lazysheep_tggo:pull:%s:%d:%s", in.BotKey, in.ChatID, shortHash(binding.SourceURL))
	mutex := lock.Mutex(pullKey)
	if lockErr := mutex.TryLock(ctx); lockErr != nil {
		if gerror.Is(lockErr, lock.ErrLockFailed) {
			return "已有采集任务正在执行，请稍后再试。", nil
		}
		return "", gerror.Wrap(lockErr, "创建采集执行锁失败")
	}
	defer func() {
		if unlockErr := mutex.Unlock(ctx); unlockErr != nil && !gerror.Is(unlockErr, lock.ErrNotExist) {
			g.Log().Warningf(ctx, "释放采集执行锁失败 key:%s err:%+v", pullKey, unlockErr)
		}
	}()

	limit := in.Limit
	if limit <= 0 {
		limit = 50
	}
	if err = s.configureBangchatProxy(ctx); err != nil {
		return "", err
	}
	result, err := bangchat.Pull(ctx, bangchat.PullOption{URL: binding.SourceURL, Limit: limit, MaxPages: 0})
	if err != nil {
		return "", gerror.Wrap(err, "采集 BangChat 消息失败")
	}
	summary := &pullSummary{Fetched: len(result.Messages), PairID: result.PairID}
	if binding.AutoPush {
		rt := s.runtime.get(in.BotKey)
		if rt == nil || rt.client == nil {
			return "", gerror.New("机器人运行实例不存在，请先启动机器人")
		}
		for _, raw := range result.Messages {
			if !isBangchatNote(raw) {
				summary.Skipped++
				continue
			}
			if pushErr := s.pushQuickCollectedNote(ctx, in.BotKey, binding, raw, in.ChatID); pushErr != nil {
				summary.Failed++
				g.Log().Warningf(ctx, "快速推送 BangChat 笔记失败 botKey:%s binding:%s err:%+v", in.BotKey, binding.Key, pushErr)
				continue
			}
			summary.QuickPushed++
		}
		return summary.Message(), nil
	}
	for _, raw := range result.Messages {
		if !isBangchatNote(raw) {
			summary.Skipped++
			continue
		}
		stored, storeErr := s.StoreNote(ctx, &lsysin.NoteStoreInp{
			BotKey:     in.BotKey,
			BindingKey: binding.Key,
			Payload:    string(raw),
		})
		if storeErr != nil {
			summary.Failed++
			g.Log().Warningf(ctx, "保存 BangChat 笔记失败 botKey:%s binding:%s err:%+v", in.BotKey, binding.Key, storeErr)
			continue
		}
		summary.Stored++
		if pushErr := s.pushCollectedNote(ctx, in.BotKey, binding, stored.NoteId, in.ChatID); pushErr != nil {
			summary.PushFailed++
			g.Log().Warningf(ctx, "推送采集笔记失败 botKey:%s noteId:%d err:%+v", in.BotKey, stored.NoteId, pushErr)
		} else {
			summary.Pushed++
		}
	}
	return summary.Message(), nil
}

type pullSummary struct {
	PairID      string
	Fetched     int
	Stored      int
	Pushed      int
	QuickPushed int
	Skipped     int
	Failed      int
	PushFailed  int
}

func (s *pullSummary) Message() string {
	if s.QuickPushed > 0 {
		return fmt.Sprintf("采集完成：获取 %d 条，快速推送 %d 条，跳过 %d 条，失败 %d 条。", s.Fetched, s.QuickPushed, s.Skipped, s.Failed)
	}
	return fmt.Sprintf("采集完成：获取 %d 条，入库 %d 条，推送 %d 条，跳过 %d 条，失败 %d 条，推送失败 %d 条。", s.Fetched, s.Stored, s.Pushed, s.Skipped, s.Failed, s.PushFailed)
}

func (s *sLazySheepTGGo) SetBindingPublishChat(ctx context.Context, botKey string, chatID int64) (message string, err error) {
	if strings.TrimSpace(botKey) == "" {
		return "", gerror.New("botKey 不能为空")
	}
	if chatID == 0 {
		return "", gerror.New("发布频道ID不能为空")
	}
	cols := dao.AddonLazysheepTggoBinding.Columns()
	result, err := dao.AddonLazysheepTggoBinding.Ctx(ctx).
		Where(cols.BotKey, botKey).
		WhereGT(cols.ReviewChatId, 0).
		Data(g.Map{cols.PublishChatId: chatID, cols.PublishEnabled: 1}).
		Update()
	if err != nil {
		return "", gerror.Wrap(err, "绑定发布频道失败")
	}
	affected, _ := result.RowsAffected()
	if affected == 0 {
		return "当前机器人还没有审核绑定。请先在审核群发送 /绑定审核 <BangChat链接>。", nil
	}
	return "发布频道绑定成功。审核群中的内容点击“发布”后，会推送到当前频道。", nil
}

func isBangchatNote(raw json.RawMessage) bool {
	var msg struct {
		Type string `json:"type"`
	}
	_ = json.Unmarshal(raw, &msg)
	return msg.Type == "MESSAGE_TYPE_NOTES"
}

func (s *sLazySheepTGGo) configureBangchatProxy(ctx context.Context) error {
	state, err := s.GetState(ctx)
	if err != nil {
		return err
	}
	proxyURL := ""
	if state != nil && state.Global != nil {
		proxyURL = strings.TrimSpace(state.Global.TelegramProxy)
	}
	if err = bangchat.SetProxy(proxyURL); err != nil {
		return gerror.Wrap(err, "配置 BangChat 代理失败")
	}
	return nil
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

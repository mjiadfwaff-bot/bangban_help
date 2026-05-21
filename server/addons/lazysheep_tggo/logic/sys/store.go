// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"fmt"
	"strconv"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"hotgo/addons/lazysheep_tggo/model"
	lsysin "hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/internal/dao"
	"hotgo/internal/model/entity"
)

func (s *sLazySheepTGGo) loadState(ctx context.Context) (res *model.State, err error) {
	res = model.NewState()
	res.Normalize()

	var bots []*entity.AddonLazysheepTggoBot
	if err = dao.AddonLazysheepTggoBot.Ctx(ctx).OrderAsc(dao.AddonLazysheepTggoBot.Columns().Id).Scan(&bots); err != nil {
		return nil, gerror.Wrap(err, "获取机器人配置失败")
	}
	for _, row := range bots {
		if row == nil {
			continue
		}
		key := row.BotKey
		if key == "" {
			key = fmt.Sprintf("%d", row.Id)
		}
		res.Bots[key] = &model.BotConfig{
			Key:           key,
			Token:         row.Token,
			DisplayName:   row.BotName,
			Username:      row.Username,
			WebhookSecret: row.WebhookSecret,
			WebhookPath:   row.WebhookPath,
			Enabled:       row.Enabled > 0,
			AutoPull:      row.AutoPull > 0,
			AutoForward:   row.AutoForward > 0,
			ReviewEnabled: row.ReviewEnabled > 0,
			CreatedAt:     row.CreatedAt,
			UpdatedAt:     row.UpdatedAt,
		}
		s.fillBotRuntimeStatus(key, res.Bots[key])
		res.Settings = &model.Settings{
			AllowVerify:   row.AllowVerify > 0,
			AllowLocation: row.AllowLocation > 0,
			MemberVerify:  memberVerifyLabel(row.MemberVerify),
			MemberPoints:  fmt.Sprintf("%d", row.MemberPoints),
			SignFollow:    row.SignFollow > 0,
		}
	}

	var users []*entity.AddonLazysheepTggoUser
	if err = dao.AddonLazysheepTggoUser.Ctx(ctx).OrderAsc(dao.AddonLazysheepTggoUser.Columns().Id).Scan(&users); err != nil {
		return nil, gerror.Wrap(err, "获取 Telegram 用户失败")
	}
	for _, row := range users {
		if row == nil {
			continue
		}
		res.Users[int64(row.TelegramId)] = &model.UserRecord{
			TelegramID:   int64(row.TelegramId),
			BotKey:       "",
			Username:     row.Username,
			FirstName:    row.FirstName,
			LastName:     row.LastName,
			LanguageCode: row.LanguageCode,
			IsBot:        row.IsBot > 0,
			MemberLevel:  row.MemberLevel,
			Points:       row.Points,
			Status:       row.Status,
			LastActiveAt: row.LastActiveAt,
			CreatedAt:    row.CreatedAt,
			UpdatedAt:    row.UpdatedAt,
		}
	}

	var bindings []*entity.AddonLazysheepTggoBinding
	if err = dao.AddonLazysheepTggoBinding.Ctx(ctx).OrderAsc(dao.AddonLazysheepTggoBinding.Columns().Id).Scan(&bindings); err != nil {
		return nil, gerror.Wrap(err, "获取绑定关系失败")
	}
	for _, row := range bindings {
		if row == nil {
			continue
		}
		key := row.BindingKey
		if key == "" {
			key = fmt.Sprintf("%d:%s:%d", row.BotId, row.SourceUrl, row.PublishChatId)
		}
		res.Bindings[key] = &model.BindingRecord{
			Key:             key,
			BotKey:          row.BotKey,
			SourceURL:       row.SourceUrl,
			SourceToken:     row.SourceToken,
			ReviewChatID:    int64(row.ReviewChatId),
			PublishChatID:   int64(row.PublishChatId),
			Status:          statusLabel(row.Status),
			AutoPush:        row.AutoPush > 0,
			VerifyEnabled:   row.VerifyEnabled > 0,
			LocationEnabled: row.LocationEnabled > 0,
			CreatedAt:       row.CreatedAt,
			UpdatedAt:       row.UpdatedAt,
		}
	}
	if err = s.loadPlugins(ctx, res); err != nil {
		return nil, err
	}
	if err = s.loadGlobal(ctx, res); err != nil {
		return nil, err
	}
	if err = s.loadBotPlugins(ctx, res); err != nil {
		return nil, err
	}

	res.Normalize()
	return
}

func (s *sLazySheepTGGo) saveState(ctx context.Context, state *model.State) error {
	if state == nil {
		state = model.NewState()
	}
	state.Normalize()

	if err := dao.AddonLazysheepTggoBot.Transaction(ctx, func(ctx context.Context, tx gdb.TX) (err error) {
		for key, item := range state.Bots {
			if item == nil {
				continue
			}
			if err = s.upsertBot(ctx, key, item, state.Settings); err != nil {
				return err
			}
		}
		for key, item := range state.Users {
			if item == nil {
				continue
			}
			if err = s.upsertUser(ctx, key, item); err != nil {
				return err
			}
		}
		for key, item := range state.Bindings {
			if item == nil {
				continue
			}
			if err = s.upsertBinding(ctx, key, item); err != nil {
				return err
			}
		}
		if err = s.savePlugins(ctx, state.Plugins); err != nil {
			return err
		}
		if err = s.saveGlobal(ctx, state.Global); err != nil {
			return err
		}
		if err = s.saveBotPlugins(ctx, state.Bots); err != nil {
			return err
		}
		return
	}); err != nil {
		return err
	}
	return s.syncWebhooksAfterSave(ctx, state)
}

func (s *sLazySheepTGGo) upsertBot(ctx context.Context, key string, item *model.BotConfig, settings *model.Settings) error {
	s.normalizeBotConfig(key, item)

	allowVerify := true
	allowLocation := true
	memberVerify := 0
	memberPoints := 0
	signFollow := false
	if settings != nil {
		allowVerify = settings.AllowVerify
		allowLocation = settings.AllowLocation
		memberVerify = memberVerifyValue(settings.MemberVerify)
		memberPoints, _ = strconv.Atoi(settings.MemberPoints)
		signFollow = settings.SignFollow
	}

	cols := dao.AddonLazysheepTggoBot.Columns()
	row := g.Map{
		cols.BotKey:        key,
		cols.Token:         item.Token,
		cols.BotName:       item.DisplayName,
		cols.Username:      item.Username,
		cols.WebhookSecret: item.WebhookSecret,
		cols.WebhookPath:   item.WebhookPath,
		cols.Enabled:       boolToInt(item.Enabled),
		cols.AutoPull:      boolToInt(item.AutoPull),
		cols.AutoForward:   boolToInt(item.AutoForward),
		cols.ReviewEnabled: boolToInt(item.ReviewEnabled),
		cols.AllowVerify:   boolToInt(allowVerify),
		cols.AllowLocation: boolToInt(allowLocation),
		cols.MemberVerify:  memberVerify,
		cols.MemberPoints:  memberPoints,
		cols.SignFollow:    boolToInt(signFollow),
		cols.Status:        1,
		cols.UpdatedAt:     gtime.Now(),
	}
	if item.CreatedAt != nil {
		row[cols.CreatedAt] = item.CreatedAt
	} else {
		row[cols.CreatedAt] = gtime.Now()
	}
	_, err := upsertByKey(ctx, dao.AddonLazysheepTggoBot.Ctx(ctx), cols.BotKey, key, row)
	return err
}

func (s *sLazySheepTGGo) deleteBot(ctx context.Context, in *lsysin.BotDeleteInp) error {
	if in == nil || in.Key == "" {
		return gerror.New("机器人标识不能为空")
	}
	cols := dao.AddonLazysheepTggoBot.Columns()
	bindingCols := dao.AddonLazysheepTggoBinding.Columns()
	return dao.AddonLazysheepTggoBot.Transaction(ctx, func(ctx context.Context, tx gdb.TX) error {
		count, err := dao.AddonLazysheepTggoBot.Ctx(ctx).Where(cols.BotKey, in.Key).Count()
		if err != nil {
			return gerror.Wrap(err, "查询机器人失败")
		}
		if count == 0 {
			return gerror.New("机器人不存在或已删除")
		}
		if _, err = dao.AddonLazysheepTggoBinding.Ctx(ctx).Where(bindingCols.BotKey, in.Key).Delete(); err != nil {
			return gerror.Wrap(err, "删除机器人绑定失败")
		}
		if _, err = dao.AddonLazysheepTggoBot.Ctx(ctx).Where(cols.BotKey, in.Key).Delete(); err != nil {
			return gerror.Wrap(err, "删除机器人失败")
		}
		s.runtime.mu.Lock()
		delete(s.runtime.runtimes, in.Key)
		s.runtime.mu.Unlock()
		return nil
	})
}

func (s *sLazySheepTGGo) upsertUser(ctx context.Context, key int64, item *model.UserRecord) error {
	cols := dao.AddonLazysheepTggoUser.Columns()
	row := g.Map{
		cols.TelegramId:   key,
		"bot_key":         item.BotKey,
		cols.Username:     item.Username,
		cols.FirstName:    item.FirstName,
		cols.LastName:     item.LastName,
		cols.LanguageCode: item.LanguageCode,
		cols.IsBot:        boolToInt(item.IsBot),
		cols.LastActiveAt: gtime.Now(),
		cols.Status:       1,
		cols.UpdatedAt:    gtime.Now(),
	}
	if item.CreatedAt != nil {
		row[cols.CreatedAt] = item.CreatedAt
	} else {
		row[cols.CreatedAt] = gtime.Now()
	}
	if item.BotKey == "" {
		return nil
	}
	existing, err := dao.AddonLazysheepTggoUser.Ctx(ctx).
		Fields(cols.Id).
		Where("bot_key", item.BotKey).
		Where(cols.TelegramId, key).
		Value()
	if err != nil {
		return gerror.Wrap(err, "查询Telegram用户失败")
	}
	if existing.IsNil() {
		count, err := dao.AddonLazysheepTggoUser.Ctx(ctx).Where("bot_key", item.BotKey).Count()
		if err != nil {
			return gerror.Wrap(err, "统计Telegram用户失败")
		}
		if count == 0 {
			row[cols.MemberLevel] = 9
		}
		_, err = dao.AddonLazysheepTggoUser.Ctx(ctx).Data(row).Insert()
		return err
	}
	adminCount, err := dao.AddonLazysheepTggoUser.Ctx(ctx).
		Where("bot_key", item.BotKey).
		WhereGTE(cols.MemberLevel, 9).
		Count()
	if err != nil {
		return gerror.Wrap(err, "统计机器人管理员失败")
	}
	if adminCount == 0 {
		row[cols.MemberLevel] = 9
	}
	_, err = dao.AddonLazysheepTggoUser.Ctx(ctx).Where(cols.Id, existing.Int64()).Data(row).Update()
	return err
}

func (s *sLazySheepTGGo) upsertBinding(ctx context.Context, key string, item *model.BindingRecord) error {
	cols := dao.AddonLazysheepTggoBinding.Columns()
	botID, err := s.resolveBotID(ctx, item.BotKey)
	if err != nil {
		return err
	}
	row := g.Map{
		cols.BindingKey:      key,
		cols.BotId:           botID,
		cols.BotKey:          item.BotKey,
		cols.SourceUrl:       item.SourceURL,
		cols.SourceToken:     item.SourceToken,
		cols.ReviewChatId:    item.ReviewChatID,
		cols.PublishChatId:   item.PublishChatID,
		cols.AutoPush:        boolToInt(item.AutoPush),
		cols.ReviewEnabled:   1,
		cols.PublishEnabled:  1,
		cols.VerifyEnabled:   boolToInt(item.VerifyEnabled),
		cols.LocationEnabled: boolToInt(item.LocationEnabled),
		cols.LastCursor:      "",
		cols.Status:          1,
		cols.UpdatedAt:       gtime.Now(),
	}
	if item.CreatedAt != nil {
		row[cols.CreatedAt] = item.CreatedAt
	} else {
		row[cols.CreatedAt] = gtime.Now()
	}
	_, err = upsertByKey(ctx, dao.AddonLazysheepTggoBinding.Ctx(ctx), cols.BindingKey, key, row)
	return err
}

func (s *sLazySheepTGGo) resolveBotID(ctx context.Context, botKey string) (int, error) {
	if botKey == "" {
		return 0, nil
	}
	cols := dao.AddonLazysheepTggoBot.Columns()
	val, err := dao.AddonLazysheepTggoBot.Ctx(ctx).Fields(cols.Id).Where(cols.BotKey, botKey).Value()
	if err != nil {
		return 0, gerror.Wrap(err, "查询机器人失败")
	}
	if val.IsNil() {
		return 0, gerror.Newf("机器人不存在：%s", botKey)
	}
	return val.Int(), nil
}

func upsertByKey(ctx context.Context, mod *gdb.Model, field string, value any, row g.Map) (int64, error) {
	existing, err := mod.Fields("id").Where(field, value).Value()
	if err != nil {
		return 0, gerror.Wrap(err, "查询记录失败")
	}
	if !existing.IsNil() {
		if _, err = mod.Where(field, value).Data(row).Update(); err != nil {
			return 0, gerror.Wrap(err, "更新记录失败")
		}
		return existing.Int64(), nil
	}
	id, err := mod.Data(row).InsertAndGetId()
	if err != nil {
		return 0, gerror.Wrap(err, "新增记录失败")
	}
	return id, nil
}

func boolToInt(v bool) int {
	if v {
		return 1
	}
	return 0
}

func statusLabel(v int) string {
	switch v {
	case 1:
		return "enabled"
	case 2:
		return "disabled"
	case 3:
		return "deleted"
	default:
		return "unknown"
	}
}

func memberVerifyValue(v string) int {
	switch v {
	case "member":
		return 1
	case "points":
		return 2
	default:
		return 0
	}
}

func memberVerifyLabel(v int) string {
	switch v {
	case 1:
		return "member"
	case 2:
		return "points"
	default:
		return "none"
	}
}

func (s *sLazySheepTGGo) fillBotRuntimeStatus(key string, item *model.BotConfig) {
	if item == nil {
		return
	}
	if !item.Enabled {
		item.RuntimeStatus = "disabled"
		item.RuntimeMessage = "未启用"
		return
	}
	rt := s.runtime.get(key)
	if rt == nil {
		item.RuntimeStatus = "pending"
		item.RuntimeMessage = ""
		return
	}
	if rt.status == "error" {
		item.RuntimeStatus = "error"
		item.RuntimeMessage = rt.lastError
		return
	}
	item.RuntimeStatus = "running"
	item.RuntimeMessage = "运行中"
}

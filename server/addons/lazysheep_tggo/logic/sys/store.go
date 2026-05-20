// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"fmt"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"hotgo/addons/lazysheep_tggo/model"
	"hotgo/internal/dao"
	"hotgo/internal/model/entity"
)

func (s *sLazySheepTGGo) loadState(ctx context.Context) (res *model.State, err error) {
	res = model.NewState()

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
			Username:     row.Username,
			FirstName:    row.FirstName,
			LastName:     row.LastName,
			LanguageCode: row.LanguageCode,
			IsBot:        row.IsBot > 0,
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
			Key:           key,
			BotKey:        row.BotKey,
			SourceURL:     row.SourceUrl,
			SourceToken:   row.SourceToken,
			ReviewChatID:  int64(row.ReviewChatId),
			PublishChatID: int64(row.PublishChatId),
			Status:        statusLabel(row.Status),
			AutoPush:      row.AutoPush > 0,
			CreatedAt:     row.CreatedAt,
			UpdatedAt:     row.UpdatedAt,
		}
	}

	res.Normalize()
	return
}

func (s *sLazySheepTGGo) saveState(ctx context.Context, state *model.State) error {
	if state == nil {
		state = model.NewState()
	}
	state.Normalize()

	return dao.AddonLazysheepTggoBot.Transaction(ctx, func(ctx context.Context, tx gdb.TX) (err error) {
		for key, item := range state.Bots {
			if item == nil {
				continue
			}
			if err = s.upsertBot(ctx, key, item); err != nil {
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
		return
	})
}

func (s *sLazySheepTGGo) upsertBot(ctx context.Context, key string, item *model.BotConfig) error {
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

func (s *sLazySheepTGGo) upsertUser(ctx context.Context, key int64, item *model.UserRecord) error {
	cols := dao.AddonLazysheepTggoUser.Columns()
	row := g.Map{
		cols.TelegramId:   key,
		cols.Username:     item.Username,
		cols.FirstName:    item.FirstName,
		cols.LastName:     item.LastName,
		cols.LanguageCode: item.LanguageCode,
		cols.IsBot:        boolToInt(item.IsBot),
		cols.Status:       1,
		cols.UpdatedAt:    gtime.Now(),
	}
	if item.CreatedAt != nil {
		row[cols.CreatedAt] = item.CreatedAt
	} else {
		row[cols.CreatedAt] = gtime.Now()
	}
	_, err := upsertByKey(ctx, dao.AddonLazysheepTggoUser.Ctx(ctx), cols.TelegramId, key, row)
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
		cols.VerifyEnabled:   1,
		cols.LocationEnabled: 1,
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

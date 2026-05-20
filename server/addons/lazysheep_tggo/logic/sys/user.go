// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"strings"

	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/internal/dao"
)

func (s *sLazySheepTGGo) botUsers(ctx context.Context, in *sysin.BotUserListInp) ([]*sysin.BotUserListModel, error) {
	if in == nil || strings.TrimSpace(in.BotKey) == "" {
		return []*sysin.BotUserListModel{}, nil
	}
	cols := dao.AddonLazysheepTggoUser.Columns()
	mod := dao.AddonLazysheepTggoUser.Ctx(ctx).Where("bot_key", strings.TrimSpace(in.BotKey))
	if in.Keyword != "" {
		keyword := "%" + strings.TrimSpace(in.Keyword) + "%"
		mod = mod.WhereLike(cols.Username, keyword).WhereOrLike(cols.FirstName, keyword).WhereOrLike(cols.LastName, keyword)
	}
	if in.MemberLevel > 0 {
		mod = mod.Where(cols.MemberLevel, in.MemberLevel)
	}
	if in.Status > 0 {
		mod = mod.Where(cols.Status, in.Status)
	}
	var rows []struct {
		Id           int
		TelegramId   int64
		BotKey       string
		Username     string
		FirstName    string
		LastName     string
		LanguageCode string
		IsBot        int
		MemberLevel  int
		Points       float64
		Status       int
		LastActiveAt *gtime.Time
		CreatedAt    *gtime.Time
	}
	if err := mod.OrderDesc(cols.LastActiveAt).OrderDesc(cols.Id).Scan(&rows); err != nil {
		return nil, gerror.Wrap(err, "获取机器人用户失败")
	}
	list := make([]*sysin.BotUserListModel, 0, len(rows))
	for _, row := range rows {
		list = append(list, &sysin.BotUserListModel{
			Id:           row.Id,
			TelegramID:   row.TelegramId,
			BotKey:       row.BotKey,
			Username:     row.Username,
			FirstName:    row.FirstName,
			LastName:     row.LastName,
			LanguageCode: row.LanguageCode,
			IsBot:        row.IsBot > 0,
			MemberLevel:  row.MemberLevel,
			Points:       row.Points,
			Status:       row.Status,
			LastActiveAt: timeString(row.LastActiveAt),
			CreatedAt:    timeString(row.CreatedAt),
		})
	}
	return list, nil
}

func (s *sLazySheepTGGo) updateBotUser(ctx context.Context, in *sysin.BotUserEditInp) error {
	if in == nil || in.Id <= 0 {
		return gerror.New("用户ID不能为空")
	}
	cols := dao.AddonLazysheepTggoUser.Columns()
	_, err := dao.AddonLazysheepTggoUser.Ctx(ctx).
		Where(cols.Id, in.Id).
		Data(g.Map{
			cols.MemberLevel: in.MemberLevel,
			cols.Points:      in.Points,
			cols.Status:      in.Status,
			cols.UpdatedAt:   gtime.Now(),
		}).
		Update()
	if err != nil {
		return gerror.Wrap(err, "更新机器人用户失败")
	}
	return nil
}

func timeString(t *gtime.Time) string {
	if t == nil {
		return ""
	}
	return t.String()
}

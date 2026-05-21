// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"fmt"
	"html"
	"strings"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"hotgo/addons/lazysheep_tggo/model"
	"hotgo/internal/dao"
)

func (s *sLazySheepTGGo) pushCollectedNote(ctx context.Context, botKey string, binding *model.BindingRecord, noteID int64, fallbackChatID int64) error {
	if binding == nil {
		return nil
	}
	targetChatID := binding.PublishChatID
	reviewMode := !binding.AutoPush && binding.ReviewChatID != 0
	if reviewMode {
		targetChatID = binding.ReviewChatID
	}
	if targetChatID == 0 {
		targetChatID = fallbackChatID
	}
	if targetChatID == 0 {
		return nil
	}
	rt := s.runtime.get(botKey)
	if rt == nil || rt.client == nil {
		return gerror.New("机器人运行实例不存在，请先启动机器人")
	}
	note, err := s.loadPushNote(ctx, noteID)
	if err != nil {
		return err
	}
	plugins := s.collectorPlugins(ctx, botKey)
	settings := map[string]any{}
	if cfg := plugins["collector"]; cfg != nil && cfg.Settings != nil {
		settings = cfg.Settings
	}
	caption := buildNoteCaption(note, rt.cfg, binding, settings)
	g.Log().Debugf(ctx, "推送采集笔记开始 botKey:%s binding:%s noteId:%d targetChat:%d reviewMode:%t", botKey, binding.Key, noteID, targetChatID, reviewMode)
	params := &bot.SendMessageParams{
		ChatID:    targetChatID,
		Text:      caption,
		ParseMode: models.ParseModeHTML,
	}
	if reviewMode {
		params.ReplyMarkup = reviewKeyboard(note.Code)
	}
	msg, err := rt.client.SendMessage(ctx, params)
	if err != nil {
		return err
	}
	g.Log().Debugf(ctx, "推送采集笔记完成 botKey:%s binding:%s noteId:%d messageID:%d", botKey, binding.Key, noteID, msg.ID)
	cols := dao.AddonLazysheepTggoNote.Columns()
	update := g.Map{cols.UpdatedAt: gtime.Now()}
	if reviewMode {
		update[cols.ReviewMessageId] = msg.ID
	} else {
		update[cols.PublishMessageId] = msg.ID
	}
	_, _ = dao.AddonLazysheepTggoNote.Ctx(ctx).WherePri(noteID).Data(update).Update()
	return nil
}

type pushNote struct {
	Id              int64
	Code            string
	Title           string
	TextContent     string
	HasVerifyVideo  bool
	HasLocation     bool
	LocationTitle   string
	LocationAddress string
}

func (s *sLazySheepTGGo) loadPushNote(ctx context.Context, noteID int64) (*pushNote, error) {
	cols := dao.AddonLazysheepTggoNote.Columns()
	var row struct {
		Id          int64  `json:"id"`
		Code        string `json:"code"`
		Title       string `json:"title"`
		TextContent string `json:"textContent"`
	}
	if err := dao.AddonLazysheepTggoNote.Ctx(ctx).
		Fields(cols.Id, cols.Code, cols.Title, cols.TextContent).
		Where(cols.Id, noteID).
		Scan(&row); err != nil {
		return nil, gerror.Wrap(err, "查询笔记失败")
	}
	if row.Id == 0 {
		return nil, gerror.New("笔记不存在")
	}
	itemCols := dao.AddonLazysheepTggoNoteItem.Columns()
	var items []struct {
		ItemType    string `json:"itemType"`
		Title       string `json:"title"`
		SubTitle    string `json:"subTitle"`
		VerifyVideo int    `json:"verifyVideo"`
	}
	if err := dao.AddonLazysheepTggoNoteItem.Ctx(ctx).
		Fields(itemCols.ItemType, itemCols.Title, itemCols.SubTitle, itemCols.VerifyVideo).
		Where(itemCols.NoteId, noteID).
		OrderAsc(itemCols.ItemIndex).
		Scan(&items); err != nil {
		return nil, gerror.Wrap(err, "查询笔记资源失败")
	}
	out := &pushNote{Id: row.Id, Code: row.Code, Title: row.Title, TextContent: row.TextContent}
	for _, item := range items {
		if item.ItemType == noteTypeLocation {
			out.HasLocation = true
			out.LocationTitle = item.Title
			out.LocationAddress = item.SubTitle
		}
		if item.ItemType == noteTypeVideo && item.VerifyVideo > 0 {
			out.HasVerifyVideo = true
		}
	}
	return out, nil
}

func (s *sLazySheepTGGo) collectorPlugins(ctx context.Context, botKey string) map[string]*model.PluginConfig {
	state, err := s.GetState(ctx)
	if err != nil || state == nil {
		return model.DefaultPluginConfigs()
	}
	if cfg := state.Bots[botKey]; cfg != nil && cfg.Plugins != nil {
		return cfg.Plugins
	}
	return state.Plugins
}

func buildNoteCaption(note *pushNote, cfg *model.BotConfig, binding *model.BindingRecord, settings map[string]any) string {
	template := pushSettingString(settings, "captionTemplate", "<b>{title}</b>\n\n{text}\n\n编号：<code>{code}</code>\n\n{verify_link}\n{location_link}\n\n{footer}")
	verifyLink := ""
	if note.HasVerifyVideo && binding.VerifyEnabled && pushSettingBool(settings, "showVerifyLink", true) {
		verifyLink = buildDeepLink(cfg, "note_"+note.Code, pushSettingString(settings, "verifyLinkText", "📒 点击查看验证视频"))
	}
	locationLink := ""
	if note.HasLocation && binding.LocationEnabled && pushSettingBool(settings, "showLocationLink", true) {
		locationLink = buildDeepLink(cfg, "loc_"+note.Code, pushSettingString(settings, "locationLinkText", "📍 点击查看位置"))
	}
	replacer := strings.NewReplacer(
		"{title}", html.EscapeString(note.Title),
		"{text}", html.EscapeString(note.TextContent),
		"{code}", html.EscapeString(note.Code),
		"{verify_link}", verifyLink,
		"{location_link}", locationLink,
		"{footer}", pushSettingString(settings, "footer", ""),
	)
	return strings.TrimSpace(replacer.Replace(template))
}

func pushSettingString(settings map[string]any, key, fallback string) string {
	if settings == nil {
		return fallback
	}
	if v, ok := settings[key].(string); ok {
		if strings.TrimSpace(v) != "" {
			return v
		}
	}
	return fallback
}

func pushSettingBool(settings map[string]any, key string, fallback bool) bool {
	if settings == nil {
		return fallback
	}
	if v, ok := settings[key].(bool); ok {
		return v
	}
	return fallback
}

func buildDeepLink(cfg *model.BotConfig, payload string, text string) string {
	username := ""
	if cfg != nil {
		username = strings.TrimPrefix(strings.TrimSpace(cfg.Username), "@")
	}
	if username == "" {
		return ""
	}
	return fmt.Sprintf(`<a href="https://t.me/%s?start=%s">%s</a>`, html.EscapeString(username), html.EscapeString(payload), html.EscapeString(text))
}

func reviewKeyboard(code string) *models.InlineKeyboardMarkup {
	return &models.InlineKeyboardMarkup{
		InlineKeyboard: [][]models.InlineKeyboardButton{
			{
				{Text: "发布", CallbackData: "collector:publish:" + code},
				{Text: "编辑文案", CallbackData: "collector:edit:" + code},
			},
			{
				{Text: "查看验证", CallbackData: "collector:verify:" + code},
				{Text: "查看位置", CallbackData: "collector:location:" + code},
			},
		},
	}
}

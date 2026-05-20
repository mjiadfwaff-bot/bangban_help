// Package telegram
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package telegram

import (
	"context"
	"fmt"
	"strings"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/model"
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/addons/lazysheep_tggo/service"
)

type menuButton struct {
	Text   string `json:"text"`
	Action string `json:"action"`
	Value  string `json:"value"`
}

func init() {
	RegisterBotPlugin(&welcomePlugin{})
	RegisterBotPlugin(&menuPlugin{})
}

func Dispatch(ctx context.Context, b *bot.Bot, req *PluginRequest) error {
	_, err := DispatchHandled(ctx, b, req)
	return err
}

func DispatchHandled(ctx context.Context, b *bot.Bot, req *PluginRequest) (bool, error) {
	if req == nil {
		return false, nil
	}
	plugins := currentBotPlugins(ctx)
	for _, p := range BotPlugins() {
		cfg := plugins[p.Key()]
		if cfg == nil || !cfg.Enabled {
			continue
		}
		handled, err := p.Handle(ctx, b, req, cfg, plugins)
		if err != nil {
			return false, err
		}
		if handled {
			return true, nil
		}
	}
	if req.Trigger == TriggerMenuButton {
		return false, nil
	}
	return false, nil
}

type welcomePlugin struct{}

func (p *welcomePlugin) Key() string { return "welcome" }

func (p *welcomePlugin) Handle(ctx context.Context, b *bot.Bot, req *PluginRequest, cfg *model.PluginConfig, plugins map[string]*model.PluginConfig) (bool, error) {
	if req.Trigger != TriggerStart || req.Update == nil || req.Update.Message == nil || req.Update.Message.From == nil {
		return false, nil
	}
	_ = service.SysLazysheepTggo().TouchUser(ctx, &sysin.TouchUserInp{
		TelegramID:   req.Update.Message.From.ID,
		BotKey:       req.BotKey,
		Username:     req.Update.Message.From.Username,
		FirstName:    req.Update.Message.From.FirstName,
		LastName:     req.Update.Message.From.LastName,
		LanguageCode: req.Update.Message.From.LanguageCode,
		IsBot:        req.Update.Message.From.IsBot,
	})
	settings := cfg.Settings
	text := settingString(settings, "welcomeText", "欢迎使用<b>懒羊羊TGGo</b>")
	params := &bot.SendMessageParams{
		ChatID:    req.Update.Message.Chat.ID,
		Text:      text,
		ParseMode: models.ParseModeHTML,
	}
	if menuCfg := plugins["menu"]; menuCfg != nil && menuCfg.Enabled {
		params.ReplyMarkup = buildReplyKeyboard(menuCfg.Settings, plugins)
	}
	if params.ReplyMarkup == nil {
		g.Log().Infof(ctx, "Telegram /start 未生成底部按钮 bot:%s", req.BotKey)
	}
	_, err := b.SendMessage(ctx, params)
	return true, err
}

type menuPlugin struct{}

func (p *menuPlugin) Key() string { return "menu" }

func (p *menuPlugin) Handle(ctx context.Context, b *bot.Bot, req *PluginRequest, cfg *model.PluginConfig, plugins map[string]*model.PluginConfig) (bool, error) {
	if req.Trigger != TriggerMenuButton || req.Update == nil || req.Update.Message == nil {
		return false, nil
	}
	text := strings.TrimSpace(req.Text)
	if text == "" {
		return false, nil
	}
	for _, row := range settingButtons(cfg.Settings) {
		for _, item := range row {
			if item.Text != text {
				continue
			}
			return true, executeMenuButton(ctx, b, req.Update.Message.Chat.ID, item)
		}
	}
	return false, nil
}

func executeMenuButton(ctx context.Context, b *bot.Bot, chatID any, item menuButton) error {
	reply := strings.TrimSpace(item.Value)
	switch item.Action {
	case "url":
		if reply == "" {
			reply = "链接未配置"
		}
	case "plugin":
		if reply == "" {
			reply = "插件功能未配置"
		}
	case "reply":
	default:
		if reply == "" {
			reply = "按钮未配置"
		}
	}
	_, err := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: chatID,
		Text:   reply,
	})
	return err
}

func buildReplyKeyboard(settings map[string]any, plugins map[string]*model.PluginConfig) *models.ReplyKeyboardMarkup {
	rows := settingButtons(settings)
	if settingBool(settings, "showPluginCommands", true) {
		commandRow := make([]menuButton, 0)
		for key, item := range plugins {
			if key == "welcome" || key == "menu" || item == nil || !item.Enabled {
				continue
			}
			if !settingBool(item.Settings, "menuVisible", false) {
				continue
			}
			command := settingString(item.Settings, "command", "")
			if command != "" {
				commandRow = append(commandRow, menuButton{Text: command, Action: "plugin", Value: command})
			}
		}
		if len(commandRow) > 0 {
			rows = append(rows, commandRow)
		}
	}
	if len(rows) == 0 {
		return nil
	}
	keyboard := make([][]models.KeyboardButton, 0, len(rows))
	for _, row := range rows {
		if len(row) == 0 {
			continue
		}
		line := make([]models.KeyboardButton, 0, len(row))
		for _, item := range row {
			if item.Text == "" {
				continue
			}
			line = append(line, models.KeyboardButton{Text: item.Text})
		}
		if len(line) > 0 {
			keyboard = append(keyboard, line)
		}
	}
	if len(keyboard) == 0 {
		return nil
	}
	return &models.ReplyKeyboardMarkup{
		Keyboard:       keyboard,
		ResizeKeyboard: true,
		IsPersistent:   true,
	}
}

func currentBotPlugins(ctx context.Context) map[string]*model.PluginConfig {
	state, err := service.SysLazysheepTggo().GetState(ctx)
	if err != nil {
		return model.DefaultPluginConfigs()
	}
	botKey := currentBotKey(ctx)
	if botKey != "" {
		if cfg := state.Bots[botKey]; cfg != nil && cfg.Plugins != nil {
			return cfg.Plugins
		}
	}
	return state.Plugins
}

func settingString(settings map[string]any, key, fallback string) string {
	if settings == nil {
		return fallback
	}
	if v, ok := settings[key].(string); ok && strings.TrimSpace(v) != "" {
		return v
	}
	return fallback
}

func settingBool(settings map[string]any, key string, fallback bool) bool {
	if settings == nil {
		return fallback
	}
	if v, ok := settings[key].(bool); ok {
		return v
	}
	return fallback
}

func hasMountedPlugin(settings map[string]any, key string) bool {
	if settings == nil {
		return false
	}
	raw, ok := settings["mountedPlugins"].([]any)
	if !ok {
		return false
	}
	for _, item := range raw {
		if strings.TrimSpace(fmt.Sprint(item)) == key {
			return true
		}
	}
	return false
}

func settingButtons(settings map[string]any) [][]menuButton {
	if settings == nil {
		return nil
	}
	raw := toAnySlice(settings["buttons"])
	rows := make([][]menuButton, 0, len(raw))
	for _, rowRaw := range raw {
		items := toAnySlice(rowRaw)
		row := make([]menuButton, 0, len(items))
		for _, itemRaw := range items {
			itemMap, ok := itemRaw.(map[string]any)
			if !ok {
				continue
			}
			row = append(row, menuButton{
				Text:   strings.TrimSpace(fmt.Sprint(itemMap["text"])),
				Action: strings.TrimSpace(fmt.Sprint(itemMap["action"])),
				Value:  strings.TrimSpace(fmt.Sprint(itemMap["value"])),
			})
		}
		rows = append(rows, row)
	}
	return rows
}

func toAnySlice(raw any) []any {
	switch v := raw.(type) {
	case []any:
		return v
	case []map[string]any:
		out := make([]any, 0, len(v))
		for _, item := range v {
			out = append(out, item)
		}
		return out
	case [][]map[string]any:
		out := make([]any, 0, len(v))
		for _, row := range v {
			out = append(out, toAnySlice(row))
		}
		return out
	default:
		return nil
	}
}

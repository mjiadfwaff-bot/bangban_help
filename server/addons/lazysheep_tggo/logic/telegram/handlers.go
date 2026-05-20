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
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/addons/lazysheep_tggo/service"
)

func init() {
	RegisterMessageHandler(&startCommand{})
	RegisterMessageHandler(&menuButtonMessage{})
	RegisterMessageHandler(&bindCommand{})
	RegisterMessageHandler(&pullCommand{})
	RegisterMessageHandler(&signCommand{})

	RegisterCallbackHandler(&reviewApproveCallback{})
	RegisterCallbackHandler(&reviewLocationCallback{})
	RegisterCallbackHandler(&reviewVerifyCallback{})
}

type startCommand struct{}

func (h *startCommand) Key() string              { return "start" }
func (h *startCommand) Pattern() string          { return "start" }
func (h *startCommand) MatchType() bot.MatchType { return bot.MatchTypeCommandStartOnly }
func (h *startCommand) Description() string      { return "记录用户身份并欢迎关注" }
func (h *startCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	return Dispatch(ctx, b, &PluginRequest{
		Trigger: TriggerStart,
		BotKey:  currentBotKey(ctx),
		Update:  update,
	})
}

type menuButtonMessage struct{}

func (h *menuButtonMessage) Key() string              { return "menu_button" }
func (h *menuButtonMessage) Pattern() string          { return "" }
func (h *menuButtonMessage) MatchType() bot.MatchType { return bot.MatchTypeExact }
func (h *menuButtonMessage) Description() string      { return "底部菜单按钮调度" }
func (h *menuButtonMessage) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if update == nil || update.Message == nil || update.Message.Text == "" {
		return nil
	}
	return Dispatch(ctx, b, &PluginRequest{
		Trigger: TriggerMenuButton,
		BotKey:  currentBotKey(ctx),
		Text:    strings.TrimSpace(update.Message.Text),
		Update:  update,
	})
}

type bindCommand struct{}

func (h *bindCommand) Key() string              { return "bind" }
func (h *bindCommand) Pattern() string          { return "绑定" }
func (h *bindCommand) MatchType() bot.MatchType { return bot.MatchTypePrefix }
func (h *bindCommand) Description() string      { return "绑定资源链接" }
func (h *bindCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if update == nil || update.Message == nil || update.Message.From == nil {
		return nil
	}
	botKey := currentBotKey(ctx)
	_ = service.SysLazysheepTggo().TouchUser(ctx, &sysin.TouchUserInp{
		TelegramID:   update.Message.From.ID,
		BotKey:       botKey,
		Username:     update.Message.From.Username,
		FirstName:    update.Message.From.FirstName,
		LastName:     update.Message.From.LastName,
		LanguageCode: update.Message.From.LanguageCode,
		IsBot:        update.Message.From.IsBot,
	})
	args := strings.TrimSpace(strings.TrimPrefix(update.Message.Text, "/绑定"))
	if args == "" {
		_, err := b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: update.Message.Chat.ID,
			Text:   "请发送 /绑定 <链接>",
		})
		return err
	}
	if botKey == "" {
		_, err := b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: update.Message.Chat.ID,
			Text:   "当前命令上下文缺少 bot 标识，请先检查 webhook 入口。",
		})
		return err
	}
	if err := service.SysLazysheepTggo().BindSource(ctx, &sysin.BindSourceInp{
		BotKey:    botKey,
		SourceURL: args,
		AutoPush:  true,
	}); err != nil {
		_, sendErr := b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: update.Message.Chat.ID,
			Text:   fmt.Sprintf("绑定失败：%v", err),
		})
		if sendErr != nil {
			return sendErr
		}
		return err
	}
	_, err := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: update.Message.Chat.ID,
		Text:   fmt.Sprintf("绑定已保存：%s", args),
	})
	return err
}

type pullCommand struct{}

func (h *pullCommand) Key() string              { return "pull" }
func (h *pullCommand) Pattern() string          { return "拉取" }
func (h *pullCommand) MatchType() bot.MatchType { return bot.MatchTypePrefix }
func (h *pullCommand) Description() string      { return "主动触发采集" }
func (h *pullCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if update == nil || update.Message == nil {
		return nil
	}
	botKey := currentBotKey(ctx)
	args := strings.TrimSpace(strings.TrimPrefix(update.Message.Text, "/拉取"))
	msg, err := service.SysLazysheepTggo().PullNow(ctx, &sysin.PullInp{
		BotKey:    botKey,
		SourceURL: args,
	})
	if err != nil {
		return err
	}
	_, sendErr := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: update.Message.Chat.ID,
		Text:   msg,
	})
	return sendErr
}

type signCommand struct{}

func (h *signCommand) Key() string              { return "sign" }
func (h *signCommand) Pattern() string          { return "签到" }
func (h *signCommand) MatchType() bot.MatchType { return bot.MatchTypePrefix }
func (h *signCommand) Description() string      { return "签到入口" }
func (h *signCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	_, err := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: update.Message.Chat.ID,
		Text:   "签到功能已接入框架，后续会加关注校验和人机验证。",
	})
	return err
}

type reviewApproveCallback struct{}

func (h *reviewApproveCallback) Key() string              { return "review_approve" }
func (h *reviewApproveCallback) Pattern() string          { return "review:approve" }
func (h *reviewApproveCallback) MatchType() bot.MatchType { return bot.MatchTypeExact }
func (h *reviewApproveCallback) Description() string      { return "审批通过" }
func (h *reviewApproveCallback) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	return replyCallback(ctx, b, update, "审批动作已接入，后续会落到审核流与频道推送。")
}

type reviewLocationCallback struct{}

func (h *reviewLocationCallback) Key() string              { return "review_location" }
func (h *reviewLocationCallback) Pattern() string          { return "review:location" }
func (h *reviewLocationCallback) MatchType() bot.MatchType { return bot.MatchTypeExact }
func (h *reviewLocationCallback) Description() string      { return "查看位置" }
func (h *reviewLocationCallback) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	return replyCallback(ctx, b, update, "位置查看动作已接入，后续会从消息笔记里提取 location。")
}

type reviewVerifyCallback struct{}

func (h *reviewVerifyCallback) Key() string              { return "review_verify" }
func (h *reviewVerifyCallback) Pattern() string          { return "review:verify" }
func (h *reviewVerifyCallback) MatchType() bot.MatchType { return bot.MatchTypeExact }
func (h *reviewVerifyCallback) Description() string      { return "查看验证" }
func (h *reviewVerifyCallback) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	return replyCallback(ctx, b, update, "验证查看动作已接入，后续会生成 start deep link。")
}

func replyCallback(ctx context.Context, b *bot.Bot, update *models.Update, text string) error {
	if update == nil || update.CallbackQuery == nil {
		return nil
	}
	_, err := b.AnswerCallbackQuery(ctx, &bot.AnswerCallbackQueryParams{
		CallbackQueryID: update.CallbackQuery.ID,
		Text:            text,
		ShowAlert:       false,
	})
	return err
}

func currentBotKey(ctx context.Context) string {
	return strings.TrimSpace(CurrentBotKey(ctx))
}

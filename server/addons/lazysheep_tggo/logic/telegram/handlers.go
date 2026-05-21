// Package telegram
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package telegram

import (
	"context"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/model/input/sysin"
	"hotgo/addons/lazysheep_tggo/service"
)

func init() {
	RegisterMessageHandler(&startCommand{})
	RegisterMessageHandler(&menuButtonMessage{})
	RegisterMessageHandler(&bindReviewCommand{})
	RegisterMessageHandler(&bindPublishCommand{})
	RegisterMessageHandler(&bindCommand{})
	RegisterMessageHandler(&pullCommand{})
	RegisterMessageHandler(&signCommand{})

	RegisterCallbackHandler(&reviewApproveCallback{})
	RegisterCallbackHandler(&reviewLocationCallback{})
	RegisterCallbackHandler(&reviewVerifyCallback{})
	RegisterCallbackHandler(&collectorCallback{})
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
	msg := messageFromUpdate(update)
	if msg == nil || msg.Text == "" {
		return nil
	}
	return Dispatch(ctx, b, &PluginRequest{
		Trigger: TriggerMenuButton,
		BotKey:  currentBotKey(ctx),
		Text:    strings.TrimSpace(msg.Text),
		Update:  update,
	})
}

type bindCommand struct{}

func (h *bindCommand) Key() string              { return "bind" }
func (h *bindCommand) Pattern() string          { return "bind" }
func (h *bindCommand) MatchType() bot.MatchType { return bot.MatchTypeCommandStartOnly }
func (h *bindCommand) Description() string      { return "绑定资源链接" }
func (h *bindCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if !pluginEnabled(ctx, "collector") {
		return nil
	}
	return handleBindSource(ctx, b, update, "quick", "/bind", "/绑定", "绑定")
}

type bindReviewCommand struct{}

func (h *bindReviewCommand) Key() string              { return "bind_review" }
func (h *bindReviewCommand) Pattern() string          { return "bind_review" }
func (h *bindReviewCommand) MatchType() bot.MatchType { return bot.MatchTypeCommandStartOnly }
func (h *bindReviewCommand) Description() string      { return "绑定审核采集链接" }
func (h *bindReviewCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if !pluginEnabled(ctx, "collector") {
		return nil
	}
	return handleBindSource(ctx, b, update, "review", "/bind_review", "/绑定审核", "绑定审核")
}

type bindPublishCommand struct{}

func (h *bindPublishCommand) Key() string              { return "bind_publish" }
func (h *bindPublishCommand) Pattern() string          { return "bind_publish" }
func (h *bindPublishCommand) MatchType() bot.MatchType { return bot.MatchTypeCommandStartOnly }
func (h *bindPublishCommand) Description() string      { return "绑定发布频道" }
func (h *bindPublishCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	msg := messageFromUpdate(update)
	if msg == nil {
		return nil
	}
	if !pluginEnabled(ctx, "collector") {
		return nil
	}
	botKey := currentBotKey(ctx)
	reply, err := service.SysLazysheepTggo().SetBindingPublishChat(ctx, botKey, msg.Chat.ID)
	if err != nil {
		reply = fmt.Sprintf("绑定发布频道失败：%v", err)
	}
	_, sendErr := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: msg.Chat.ID,
		Text:   reply,
	})
	if sendErr != nil {
		return sendErr
	}
	return err
}

func handleBindSource(ctx context.Context, b *bot.Bot, update *models.Update, mode string, commands ...string) error {
	msg := messageFromUpdate(update)
	if msg == nil {
		return nil
	}
	botKey := currentBotKey(ctx)
	if msg.From != nil {
		_ = service.SysLazysheepTggo().TouchUser(ctx, &sysin.TouchUserInp{
			TelegramID:   msg.From.ID,
			BotKey:       botKey,
			Username:     msg.From.Username,
			FirstName:    msg.From.FirstName,
			LastName:     msg.From.LastName,
			LanguageCode: msg.From.LanguageCode,
			IsBot:        msg.From.IsBot,
		})
	}
	args := commandArgs(msg.Text, commands...)
	if args == "" {
		_, err := b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: msg.Chat.ID,
			Text:   fmt.Sprintf("请发送 %s <BangChat链接>", commands[0]),
		})
		return err
	}
	if botKey == "" {
		_, err := b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: msg.Chat.ID,
			Text:   "当前命令上下文缺少 bot 标识，请先检查 webhook 入口。",
		})
		return err
	}
	if err := service.SysLazysheepTggo().BindSource(ctx, &sysin.BindSourceInp{
		BotKey:    botKey,
		ChatID:    msg.Chat.ID,
		Mode:      mode,
		SourceURL: strings.Fields(args)[0],
	}); err != nil {
		_, sendErr := b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: msg.Chat.ID,
			Text:   fmt.Sprintf("绑定失败：%v", err),
		})
		if sendErr != nil {
			return sendErr
		}
		return err
	}
	_, err := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: msg.Chat.ID,
		Text:   fmt.Sprintf("绑定已保存：%s\n\n发送 /pull 可立即采集。", strings.Fields(args)[0]),
	})
	return err
}

type pullCommand struct{}

func (h *pullCommand) Key() string              { return "pull" }
func (h *pullCommand) Pattern() string          { return "pull" }
func (h *pullCommand) MatchType() bot.MatchType { return bot.MatchTypeCommandStartOnly }
func (h *pullCommand) Description() string      { return "主动触发采集" }
func (h *pullCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if !pluginEnabled(ctx, "collector") {
		return nil
	}
	msg := messageFromUpdate(update)
	if msg == nil {
		return nil
	}
	botKey := currentBotKey(ctx)
	args := commandArgs(msg.Text, "/pull", "/拉取", "拉取")
	limit := 0
	sourceURL := ""
	if args != "" {
		fields := strings.Fields(args)
		if len(fields) > 0 {
			if n, parseErr := strconv.Atoi(fields[0]); parseErr == nil && n > 0 {
				limit = n
				if len(fields) > 1 {
					sourceURL = fields[1]
				}
			} else {
				sourceURL = fields[0]
			}
		}
	}
	progress, sendProgressErr := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: msg.Chat.ID,
		Text:   pullProgressText(limit),
	})

	taskCtx, cancel := context.WithTimeout(WithBotKey(context.Background(), botKey), 15*time.Minute)
	go func() {
		defer cancel()
		result, err := service.SysLazysheepTggo().PullNow(taskCtx, &sysin.PullInp{
			BotKey:    botKey,
			SourceURL: sourceURL,
			ChatID:    msg.Chat.ID,
			Limit:     limit,
		})
		if err != nil {
			g.Log().Warningf(taskCtx, "Telegram pull task failed bot:%s chat:%d err:%+v", botKey, msg.Chat.ID, err)
			editOrSendPullResult(taskCtx, b, msg.Chat.ID, progress, sendProgressErr, fmt.Sprintf("采集失败：%v", err))
			return
		}
		editOrSendPullResult(taskCtx, b, msg.Chat.ID, progress, sendProgressErr, result)
	}()
	return nil
}

func editOrSendPullResult(ctx context.Context, b *bot.Bot, chatID int64, progress *models.Message, progressErr error, text string) {
	if progressErr == nil && progress != nil {
		if _, err := b.EditMessageText(ctx, &bot.EditMessageTextParams{
			ChatID:    chatID,
			MessageID: progress.ID,
			Text:      text,
		}); err == nil {
			return
		}
	}
	_, _ = b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: chatID,
		Text:   text,
	})
}

func pullProgressText(limit int) string {
	if limit > 0 {
		return fmt.Sprintf("已启动采集，本次最多拉取 %d 条，请稍等。", limit)
	}
	return "已启动采集，请稍等。"
}

type signCommand struct{}

func (h *signCommand) Key() string              { return "sign" }
func (h *signCommand) Pattern() string          { return "sign" }
func (h *signCommand) MatchType() bot.MatchType { return bot.MatchTypeCommandStartOnly }
func (h *signCommand) Description() string      { return "签到入口" }
func (h *signCommand) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if !pluginEnabled(ctx, "signin") {
		return nil
	}
	msg := messageFromUpdate(update)
	if msg == nil {
		return nil
	}
	_, err := b.SendMessage(ctx, &bot.SendMessageParams{
		ChatID: msg.Chat.ID,
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
	if !pluginEnabled(ctx, "review") {
		return nil
	}
	return replyCallback(ctx, b, update, "审批动作已接入，后续会落到审核流与频道推送。")
}

type reviewLocationCallback struct{}

func (h *reviewLocationCallback) Key() string              { return "review_location" }
func (h *reviewLocationCallback) Pattern() string          { return "review:location" }
func (h *reviewLocationCallback) MatchType() bot.MatchType { return bot.MatchTypeExact }
func (h *reviewLocationCallback) Description() string      { return "查看位置" }
func (h *reviewLocationCallback) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if !pluginEnabled(ctx, "review") {
		return nil
	}
	return replyCallback(ctx, b, update, "位置查看动作已接入，后续会从消息笔记里提取 location。")
}

type reviewVerifyCallback struct{}

func (h *reviewVerifyCallback) Key() string              { return "review_verify" }
func (h *reviewVerifyCallback) Pattern() string          { return "review:verify" }
func (h *reviewVerifyCallback) MatchType() bot.MatchType { return bot.MatchTypeExact }
func (h *reviewVerifyCallback) Description() string      { return "查看验证" }
func (h *reviewVerifyCallback) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if !pluginEnabled(ctx, "review") {
		return nil
	}
	return replyCallback(ctx, b, update, "验证查看动作已接入，后续会生成 start deep link。")
}

type collectorCallback struct{}

func (h *collectorCallback) Key() string              { return "collector" }
func (h *collectorCallback) Pattern() string          { return "collector:" }
func (h *collectorCallback) MatchType() bot.MatchType { return bot.MatchTypePrefix }
func (h *collectorCallback) Description() string      { return "采集审核按钮" }
func (h *collectorCallback) Handle(ctx context.Context, b *bot.Bot, update *models.Update) error {
	if update == nil || update.CallbackQuery == nil {
		return nil
	}
	if !pluginEnabled(ctx, "collector") {
		return nil
	}
	data := update.CallbackQuery.Data
	switch {
	case strings.HasPrefix(data, "collector:publish:"):
		return replyCallback(ctx, b, update, "发布动作已收到。下一步会把该编号内容推送到绑定的公开频道。")
	case strings.HasPrefix(data, "collector:edit:"):
		return replyCallback(ctx, b, update, "编辑动作已收到。下一步会进入文案编辑会话。")
	case strings.HasPrefix(data, "collector:verify:"):
		return replyCallback(ctx, b, update, "验证视频已保存在笔记中，公开入口会通过私聊链接打开。")
	case strings.HasPrefix(data, "collector:location:"):
		return replyCallback(ctx, b, update, "位置已保存在笔记中，公开入口会通过私聊链接打开。")
	default:
		return replyCallback(ctx, b, update, "未知采集操作。")
	}
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

func pluginEnabled(ctx context.Context, key string) bool {
	plugins := currentBotPlugins(ctx)
	if len(plugins) == 0 {
		return false
	}
	cfg := plugins[key]
	return cfg != nil && cfg.Enabled
}

func messageFromUpdate(update *models.Update) *models.Message {
	if update == nil {
		return nil
	}
	if update.Message != nil {
		return update.Message
	}
	if update.ChannelPost != nil {
		return update.ChannelPost
	}
	if update.EditedChannelPost != nil {
		return update.EditedChannelPost
	}
	if update.EditedMessage != nil {
		return update.EditedMessage
	}
	return nil
}

func commandArgs(text string, commands ...string) string {
	text = strings.TrimSpace(text)
	for _, command := range commands {
		command = strings.TrimSpace(command)
		if command == "" {
			continue
		}
		if strings.HasPrefix(text, command+" ") {
			return strings.TrimSpace(strings.TrimPrefix(text, command))
		}
		if text == command {
			return ""
		}
		if strings.HasPrefix(text, command+"@") {
			parts := strings.SplitN(text, " ", 2)
			if len(parts) == 2 {
				return strings.TrimSpace(parts[1])
			}
			return ""
		}
	}
	return text
}

// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"hotgo/addons/lazysheep_tggo/logic/telegram"
	"hotgo/addons/lazysheep_tggo/model"
	lsysin "hotgo/addons/lazysheep_tggo/model/input/sysin"
)

type runtimeStore struct {
	mu       sync.RWMutex
	runtimes map[string]*runtimeBot
}

type runtimeBot struct {
	key       string
	cfg       *model.BotConfig
	client    *bot.Bot
	cancel    context.CancelFunc
	mode      string
	status    string
	lastError string
}

func newRuntimeStore() *runtimeStore {
	return &runtimeStore{runtimes: map[string]*runtimeBot{}}
}

func (s *runtimeStore) Reset() {
	s.mu.Lock()
	defer s.mu.Unlock()
	for _, rt := range s.runtimes {
		if rt != nil && rt.cancel != nil {
			rt.cancel()
		}
	}
	s.runtimes = map[string]*runtimeBot{}
}

func (s *runtimeStore) get(key string) *runtimeBot {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.runtimes[key]
}

func (s *runtimeStore) set(key string, rt *runtimeBot) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if old := s.runtimes[key]; old != nil && old.cancel != nil {
		old.cancel()
	}
	s.runtimes[key] = rt
}

func (s *sLazySheepTGGo) GetRuntime(ctx context.Context, botKey string) (res *model.Runtime, err error) {
	state, err := s.GetState(ctx)
	if err != nil {
		return nil, err
	}
	cfg, ok := state.Bots[botKey]
	if !ok || cfg == nil {
		return nil, fmt.Errorf("bot not found: %s", botKey)
	}
	return &model.Runtime{BotKey: cfg.Key, Enabled: cfg.Enabled}, nil
}

func (s *sLazySheepTGGo) SyncAllBots(ctx context.Context) error {
	state, err := s.GetState(ctx)
	if err != nil {
		return err
	}
	for key := range state.Bots {
		if err := s.SyncBot(ctx, key); err != nil {
			return err
		}
	}
	return nil
}

func (s *sLazySheepTGGo) SyncBot(ctx context.Context, botKey string) error {
	state, err := s.GetState(ctx)
	if err != nil {
		return err
	}
	cfg, ok := state.Bots[botKey]
	if !ok || cfg == nil {
		return fmt.Errorf("bot not found: %s", botKey)
	}
	if !cfg.Enabled {
		s.runtime.mu.Lock()
		if old := s.runtime.runtimes[botKey]; old != nil && old.cancel != nil {
			old.cancel()
		}
		delete(s.runtime.runtimes, botKey)
		s.runtime.mu.Unlock()
		return nil
	}
	client, err := s.buildClient(ctx, cfg)
	if err != nil {
		s.runtime.set(botKey, &runtimeBot{
			key:       botKey,
			cfg:       cfg,
			status:    "error",
			lastError: err.Error(),
		})
		return err
	}
	s.runtime.set(botKey, &runtimeBot{
		key:    botKey,
		cfg:    cfg,
		client: client,
		mode:   "webhook",
		status: "running",
	})
	return nil
}

func (s *sLazySheepTGGo) startPollingBot(ctx context.Context, botKey string) error {
	state, err := s.GetState(ctx)
	if err != nil {
		return err
	}
	cfg, ok := state.Bots[botKey]
	if !ok || cfg == nil {
		return fmt.Errorf("bot not found: %s", botKey)
	}
	if !cfg.Enabled {
		return s.SyncBot(ctx, botKey)
	}
	client, err := s.buildClient(ctx, cfg)
	if err != nil {
		s.runtime.set(botKey, &runtimeBot{
			key:       botKey,
			cfg:       cfg,
			status:    "error",
			lastError: err.Error(),
		})
		return err
	}
	if _, err = client.DeleteWebhook(ctx, &bot.DeleteWebhookParams{DropPendingUpdates: false}); err != nil {
		if strings.Contains(err.Error(), "unexpected end of JSON input") {
			g.Log().Warningf(ctx, "Telegram deleteWebhook 返回体异常，继续尝试 polling bot:%s err:%+v", botKey, err)
		} else {
			s.runtime.set(botKey, &runtimeBot{
				key:       botKey,
				cfg:       cfg,
				status:    "error",
				lastError: err.Error(),
			})
			return err
		}
	}
	pollCtx, cancel := context.WithCancel(telegram.WithBotKey(context.Background(), botKey))
	s.runtime.set(botKey, &runtimeBot{
		key:    botKey,
		cfg:    cfg,
		client: client,
		cancel: cancel,
		mode:   "polling",
		status: "running",
	})
	go func() {
		g.Log().Infof(ctx, "Telegram bot polling 已启动 bot:%s", botKey)
		client.Start(pollCtx)
		g.Log().Infof(ctx, "Telegram bot polling 已停止 bot:%s", botKey)
	}()
	return nil
}

func (s *sLazySheepTGGo) HandleWebhook(ctx context.Context, botKey string, payload []byte, secretToken string) error {
	rt := s.runtime.get(botKey)
	if rt == nil {
		if err := s.SyncBot(ctx, botKey); err != nil {
			return err
		}
		rt = s.runtime.get(botKey)
	}
	if rt == nil || rt.client == nil {
		return fmt.Errorf("bot runtime not ready: %s", botKey)
	}
	if rt.cfg.WebhookSecret == "" || secretToken != rt.cfg.WebhookSecret {
		return fmt.Errorf("telegram webhook secret mismatch: %s", botKey)
	}
	var update models.Update
	if err := json.Unmarshal(payload, &update); err != nil {
		return err
	}
	rt.client.ProcessUpdate(telegram.WithBotKey(ctx, botKey), &update)
	return nil
}

func (s *sLazySheepTGGo) SetWebhook(ctx context.Context, botKey, webhookURL string) error {
	state, err := s.GetState(ctx)
	if err != nil {
		return err
	}
	cfg, ok := state.Bots[botKey]
	if !ok || cfg == nil {
		return fmt.Errorf("bot not found: %s", botKey)
	}
	body := g.Map{
		"url":             webhookURL,
		"secret_token":    cfg.WebhookSecret,
		"allowed_updates": []string{"message", "callback_query"},
	}
	raw, _ := json.Marshal(body)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, fmt.Sprintf("https://api.telegram.org/bot%s/setWebhook", cfg.Token), bytes.NewReader(raw))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	httpClient, err := s.telegramHTTPClient(ctx)
	if err != nil {
		return err
	}
	resp, err := httpClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	out, _ := io.ReadAll(resp.Body)
	if resp.StatusCode >= 300 {
		return fmt.Errorf("set webhook failed: %s", string(out))
	}
	return nil
}

func (s *sLazySheepTGGo) buildClient(ctx context.Context, cfg *model.BotConfig) (*bot.Bot, error) {
	httpClient, err := s.telegramHTTPClient(ctx)
	if err != nil {
		return nil, err
	}
	opts := []bot.Option{
		bot.WithHTTPClient(telegramHTTPTimeout-time.Second, httpClient),
		bot.WithDefaultHandler(s.defaultHandler(cfg.Key)),
	}
	if cfg.WebhookSecret != "" {
		opts = append(opts, bot.WithWebhookSecretToken(cfg.WebhookSecret))
	}
	client, err := bot.New(cfg.Token, opts...)
	if err != nil {
		return nil, err
	}
	s.registerBotCommands(ctx, client, cfg)
	for _, h := range telegram.MessageHandlers() {
		handler := h
		client.RegisterHandler(bot.HandlerTypeMessageText, handler.Pattern(), handler.MatchType(), func(ctx context.Context, b *bot.Bot, update *models.Update) {
			ctx = telegram.WithBotKey(ctx, cfg.Key)
			if err := handler.Handle(ctx, b, update); err != nil {
				g.Log().Warningf(ctx, "telegram message handler failed bot:%s handler:%s err:%+v", cfg.Key, handler.Key(), err)
			}
		})
	}
	for _, h := range telegram.CallbackHandlers() {
		handler := h
		client.RegisterHandler(bot.HandlerTypeCallbackQueryData, handler.Pattern(), handler.MatchType(), func(ctx context.Context, b *bot.Bot, update *models.Update) {
			ctx = telegram.WithBotKey(ctx, cfg.Key)
			if err := handler.Handle(ctx, b, update); err != nil {
				g.Log().Warningf(ctx, "telegram callback handler failed bot:%s handler:%s err:%+v", cfg.Key, handler.Key(), err)
			}
		})
	}
	return client, nil
}

func (s *sLazySheepTGGo) registerBotCommands(ctx context.Context, client *bot.Bot, cfg *model.BotConfig) {
	commands := []models.BotCommand{
		{Command: "start", Description: "打开欢迎语和底部菜单"},
	}
	if _, err := client.SetMyCommands(ctx, &bot.SetMyCommandsParams{Commands: commands}); err != nil {
		g.Log().Warningf(ctx, "注册 Telegram 命令菜单失败 bot:%s err:%+v", cfg.Key, err)
	}
	if _, err := client.SetChatMenuButton(ctx, &bot.SetChatMenuButtonParams{
		MenuButton: &models.MenuButtonCommands{},
	}); err != nil {
		g.Log().Warningf(ctx, "注册 Telegram 菜单按钮失败 bot:%s err:%+v", cfg.Key, err)
	}
}

func (s *sLazySheepTGGo) inspectBot(ctx context.Context, in *lsysin.BotInspectInp) (*lsysin.BotInspectModel, error) {
	if in == nil || strings.TrimSpace(in.Token) == "" {
		return nil, fmt.Errorf("Bot Token 不能为空")
	}
	httpClient, err := s.telegramHTTPClient(ctx)
	if err != nil {
		return nil, err
	}
	client, err := bot.New(strings.TrimSpace(in.Token), bot.WithHTTPClient(telegramHTTPTimeout-time.Second, httpClient))
	if err != nil {
		return nil, err
	}
	user, err := client.GetMe(ctx)
	if err != nil {
		return nil, err
	}
	displayName := strings.TrimSpace(strings.Join([]string{user.FirstName, user.LastName}, " "))
	if displayName == "" {
		displayName = user.Username
	}
	return &lsysin.BotInspectModel{
		Id:          user.ID,
		Username:    user.Username,
		DisplayName: displayName,
		IsBot:       user.IsBot,
	}, nil
}

func (s *sLazySheepTGGo) defaultHandler(botKey string) func(ctx context.Context, b *bot.Bot, update *models.Update) {
	return func(ctx context.Context, b *bot.Bot, update *models.Update) {
		ctx = telegram.WithBotKey(ctx, botKey)
		if update == nil || update.Message == nil || update.Message.Text == "" {
			return
		}
		text := strings.TrimSpace(update.Message.Text)
		trigger := telegram.TriggerMenuButton
		if text == "/start" || strings.HasPrefix(text, "/start ") {
			trigger = telegram.TriggerStart
		}
		handled, err := telegram.DispatchHandled(ctx, b, &telegram.PluginRequest{
			Trigger: trigger,
			BotKey:  botKey,
			Text:    text,
			Update:  update,
		})
		if err != nil {
			g.Log().Warningf(ctx, "telegram default dispatch failed bot:%s err:%+v", botKey, err)
			return
		}
		if handled {
			return
		}
		if text == "" {
			return
		}
		_, _ = b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: update.Message.Chat.ID,
			Text:   "命令未注册，请先在后台启用对应插件命令。",
		})
	}
}

func (s *sLazySheepTGGo) ensureLastUpdated(state *model.State) {
	if state == nil {
		return
	}
	state.UpdatedAt = gtime.Now()
}

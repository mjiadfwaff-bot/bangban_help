// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"bytes"
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
	"hotgo/addons/lazysheep_tggo/logic/telegram"
	"hotgo/addons/lazysheep_tggo/model"
)

type runtimeStore struct {
	mu       sync.RWMutex
	runtimes map[string]*runtimeBot
}

type runtimeBot struct {
	key    string
	cfg    *model.BotConfig
	client *bot.Bot
}

func newRuntimeStore() *runtimeStore {
	return &runtimeStore{runtimes: map[string]*runtimeBot{}}
}

func (s *runtimeStore) Reset() {
	s.mu.Lock()
	defer s.mu.Unlock()
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
		delete(s.runtime.runtimes, botKey)
		s.runtime.mu.Unlock()
		return nil
	}
	client, err := s.buildClient(ctx, cfg)
	if err != nil {
		return err
	}
	s.runtime.set(botKey, &runtimeBot{
		key:    botKey,
		cfg:    cfg,
		client: client,
	})
	return nil
}

func (s *sLazySheepTGGo) HandleWebhook(ctx context.Context, botKey string, payload []byte) error {
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
	var update models.Update
	if err := json.Unmarshal(payload, &update); err != nil {
		return err
	}
	rt.client.ProcessUpdate(ctx, &update)
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
	resp, err := http.DefaultClient.Do(req)
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
	opts := []bot.Option{
		bot.WithDefaultHandler(s.defaultHandler(cfg.Key)),
	}
	if cfg.WebhookSecret != "" {
		opts = append(opts, bot.WithWebhookSecretToken(cfg.WebhookSecret))
	}
	client, err := bot.New(cfg.Token, opts...)
	if err != nil {
		return nil, err
	}
	for _, h := range telegram.MessageHandlers() {
		handler := h
		client.RegisterHandler(bot.HandlerTypeMessageText, handler.Pattern(), handler.MatchType(), func(ctx context.Context, b *bot.Bot, update *models.Update) {
			if err := handler.Handle(ctx, b, update); err != nil {
				g.Log().Warningf(ctx, "telegram message handler failed bot:%s handler:%s err:%+v", cfg.Key, handler.Key(), err)
			}
		})
	}
	for _, h := range telegram.CallbackHandlers() {
		handler := h
		client.RegisterHandler(bot.HandlerTypeCallbackQueryData, handler.Pattern(), handler.MatchType(), func(ctx context.Context, b *bot.Bot, update *models.Update) {
			if err := handler.Handle(ctx, b, update); err != nil {
				g.Log().Warningf(ctx, "telegram callback handler failed bot:%s handler:%s err:%+v", cfg.Key, handler.Key(), err)
			}
		})
	}
	return client, nil
}

func (s *sLazySheepTGGo) defaultHandler(botKey string) func(ctx context.Context, b *bot.Bot, update *models.Update) {
	return func(ctx context.Context, b *bot.Bot, update *models.Update) {
		if update == nil || update.Message == nil || update.Message.Text == "" {
			return
		}
		text := strings.TrimSpace(update.Message.Text)
		if text == "" {
			return
		}
		_, _ = b.SendMessage(ctx, &bot.SendMessageParams{
			ChatID: update.Message.Chat.ID,
			Text:   "命令未注册，请先在后台启用对应插件命令。",
		})
	}
}

func shortHash(raw string) string {
	sum := sha256.Sum256([]byte(raw))
	return hex.EncodeToString(sum[:])[:12]
}

func (s *sLazySheepTGGo) ensureLastUpdated(state *model.State) {
	if state == nil {
		return
	}
	state.UpdatedAt = gtime.Now()
}

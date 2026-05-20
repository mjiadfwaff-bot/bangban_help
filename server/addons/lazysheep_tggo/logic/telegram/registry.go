// Package telegram
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package telegram

import (
	"context"
	"sync"

	"github.com/go-telegram/bot"
	"github.com/go-telegram/bot/models"
)

type MessageHandler interface {
	Key() string
	Pattern() string
	MatchType() bot.MatchType
	Description() string
	Handle(ctx context.Context, b *bot.Bot, update *models.Update) error
}

type CallbackHandler interface {
	Key() string
	Pattern() string
	MatchType() bot.MatchType
	Description() string
	Handle(ctx context.Context, b *bot.Bot, update *models.Update) error
}

var (
	messageHandlers  = make([]MessageHandler, 0, 8)
	callbackHandlers = make([]CallbackHandler, 0, 8)
	handlerMu        sync.RWMutex
)

func RegisterMessageHandler(h MessageHandler) {
	handlerMu.Lock()
	defer handlerMu.Unlock()
	messageHandlers = append(messageHandlers, h)
}

func RegisterCallbackHandler(h CallbackHandler) {
	handlerMu.Lock()
	defer handlerMu.Unlock()
	callbackHandlers = append(callbackHandlers, h)
}

func MessageHandlers() []MessageHandler {
	handlerMu.RLock()
	defer handlerMu.RUnlock()
	out := make([]MessageHandler, len(messageHandlers))
	copy(out, messageHandlers)
	return out
}

func CallbackHandlers() []CallbackHandler {
	handlerMu.RLock()
	defer handlerMu.RUnlock()
	out := make([]CallbackHandler, len(callbackHandlers))
	copy(out, callbackHandlers)
	return out
}

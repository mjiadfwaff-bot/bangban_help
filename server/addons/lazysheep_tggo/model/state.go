// Package model
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package model

import "github.com/gogf/gf/v2/os/gtime"

type State struct {
	Bots      map[string]*BotConfig     `json:"bots"`
	Users     map[int64]*UserRecord     `json:"users"`
	Bindings  map[string]*BindingRecord `json:"bindings"`
	Settings  *Settings                 `json:"settings"`
	UpdatedAt *gtime.Time               `json:"updatedAt"`
}

type BotConfig struct {
	Key           string      `json:"key"`
	Token         string      `json:"token"`
	DisplayName   string      `json:"displayName"`
	Username      string      `json:"username"`
	WebhookSecret string      `json:"webhookSecret"`
	WebhookPath   string      `json:"webhookPath"`
	Enabled       bool        `json:"enabled"`
	AutoPull      bool        `json:"autoPull"`
	AutoForward   bool        `json:"autoForward"`
	ReviewEnabled bool        `json:"reviewEnabled"`
	CreatedAt     *gtime.Time `json:"createdAt"`
	UpdatedAt     *gtime.Time `json:"updatedAt"`
}

type UserRecord struct {
	TelegramID   int64       `json:"telegramId"`
	Username     string      `json:"username"`
	FirstName    string      `json:"firstName"`
	LastName     string      `json:"lastName"`
	LanguageCode string      `json:"languageCode"`
	IsBot        bool        `json:"isBot"`
	CreatedAt    *gtime.Time `json:"createdAt"`
	UpdatedAt    *gtime.Time `json:"updatedAt"`
}

type BindingRecord struct {
	Key           string      `json:"key"`
	BotKey        string      `json:"botKey"`
	SourceURL     string      `json:"sourceUrl"`
	SourceToken   string      `json:"sourceToken"`
	ReviewChatID  int64       `json:"reviewChatId"`
	PublishChatID int64       `json:"publishChatId"`
	Status        string      `json:"status"`
	AutoPush      bool        `json:"autoPush"`
	CreatedAt     *gtime.Time `json:"createdAt"`
	UpdatedAt     *gtime.Time `json:"updatedAt"`
}

type Settings struct {
	AllowVerify   bool   `json:"allowVerify"`
	AllowLocation bool   `json:"allowLocation"`
	MemberVerify  string `json:"memberVerify"`
	MemberPoints  string `json:"memberPoints"`
	SignFollow    bool   `json:"signFollow"`
}

type Runtime struct {
	BotKey  string `json:"botKey"`
	Enabled bool   `json:"enabled"`
}

func NewState() *State {
	return &State{}
}

func (s *State) Normalize() {
	if s.Bots == nil {
		s.Bots = map[string]*BotConfig{}
	}
	if s.Users == nil {
		s.Users = map[int64]*UserRecord{}
	}
	if s.Bindings == nil {
		s.Bindings = map[string]*BindingRecord{}
	}
	if s.Settings == nil {
		s.Settings = &Settings{}
	}
	if s.UpdatedAt == nil {
		s.UpdatedAt = gtime.Now()
	}
}

func (s *State) Clone() *State {
	if s == nil {
		return NewState()
	}
	out := NewState()
	*out = *s
	out.Normalize()
	return out
}

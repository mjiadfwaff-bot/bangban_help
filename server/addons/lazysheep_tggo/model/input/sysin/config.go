// Package sysin
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sysin

import (
	"encoding/json"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/addons/lazysheep_tggo/model"
)

type GetConfigInp struct {
	Group string `json:"group"`
}

type GetConfigModel struct {
	List g.Map `json:"list"`
}

type UpdateConfigInp struct {
	Group string `json:"group"`
	List  g.Map  `json:"list"`
}

func (in *GetConfigInp) ToModel(state *model.State) *GetConfigModel {
	return &GetConfigModel{List: g.Map{"state": state}}
}

func (in *UpdateConfigInp) ToState() *model.State {
	state := model.NewState()
	if raw, ok := in.List["state"]; ok {
		switch v := raw.(type) {
		case string:
			_ = json.Unmarshal([]byte(v), state)
		default:
			data, _ := json.Marshal(v)
			_ = json.Unmarshal(data, state)
		}
	}
	state.Normalize()
	return state
}

type BotUpsertInp struct {
	Key           string `json:"key"`
	Token         string `json:"token"`
	DisplayName   string `json:"displayName"`
	WebhookSecret string `json:"webhookSecret"`
	WebhookPath   string `json:"webhookPath"`
	Enabled       bool   `json:"enabled"`
	AutoPull      bool   `json:"autoPull"`
	AutoForward   bool   `json:"autoForward"`
	ReviewEnabled bool   `json:"reviewEnabled"`
}

type TouchUserInp struct {
	TelegramID   int64  `json:"telegramId"`
	Username     string `json:"username"`
	FirstName    string `json:"firstName"`
	LastName     string `json:"lastName"`
	LanguageCode string `json:"languageCode"`
	IsBot        bool   `json:"isBot"`
}

type BindSourceInp struct {
	BotKey        string `json:"botKey"`
	SourceURL     string `json:"sourceUrl"`
	SourceToken   string `json:"sourceToken"`
	ReviewChatID  int64  `json:"reviewChatId"`
	PublishChatID int64  `json:"publishChatId"`
	AutoPush      bool   `json:"autoPush"`
}

type PullInp struct {
	BotKey    string `json:"botKey"`
	SourceURL string `json:"sourceUrl"`
}

type SignInInp struct {
	BotKey string `json:"botKey"`
	UserID int64  `json:"userId"`
}

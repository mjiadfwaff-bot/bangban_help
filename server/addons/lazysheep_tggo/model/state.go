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
	Plugins   map[string]*PluginConfig  `json:"plugins"`
	Settings  *Settings                 `json:"settings"`
	Global    *GlobalConfig             `json:"global"`
	UpdatedAt *gtime.Time               `json:"updatedAt"`
}

type BotConfig struct {
	Key            string                   `json:"key"`
	Token          string                   `json:"token"`
	DisplayName    string                   `json:"displayName"`
	Username       string                   `json:"username"`
	WebhookSecret  string                   `json:"webhookSecret"`
	WebhookPath    string                   `json:"webhookPath"`
	RuntimeStatus  string                   `json:"runtimeStatus"`
	RuntimeMessage string                   `json:"runtimeMessage"`
	Enabled        bool                     `json:"enabled"`
	AutoPull       bool                     `json:"autoPull"`
	AutoForward    bool                     `json:"autoForward"`
	ReviewEnabled  bool                     `json:"reviewEnabled"`
	Plugins        map[string]*PluginConfig `json:"plugins"`
	CreatedAt      *gtime.Time              `json:"createdAt"`
	UpdatedAt      *gtime.Time              `json:"updatedAt"`
}

type UserRecord struct {
	TelegramID   int64       `json:"telegramId"`
	BotKey       string      `json:"botKey"`
	Username     string      `json:"username"`
	FirstName    string      `json:"firstName"`
	LastName     string      `json:"lastName"`
	LanguageCode string      `json:"languageCode"`
	IsBot        bool        `json:"isBot"`
	MemberLevel  int         `json:"memberLevel"`
	Points       float64     `json:"points"`
	Status       int         `json:"status"`
	LastActiveAt *gtime.Time `json:"lastActiveAt"`
	CreatedAt    *gtime.Time `json:"createdAt"`
	UpdatedAt    *gtime.Time `json:"updatedAt"`
}

type BindingRecord struct {
	Key             string      `json:"key"`
	BotKey          string      `json:"botKey"`
	SourceURL       string      `json:"sourceUrl"`
	SourceToken     string      `json:"sourceToken"`
	ReviewChatID    int64       `json:"reviewChatId"`
	PublishChatID   int64       `json:"publishChatId"`
	Status          string      `json:"status"`
	AutoPush        bool        `json:"autoPush"`
	VerifyEnabled   bool        `json:"verifyEnabled"`
	LocationEnabled bool        `json:"locationEnabled"`
	CreatedAt       *gtime.Time `json:"createdAt"`
	UpdatedAt       *gtime.Time `json:"updatedAt"`
}

type Settings struct {
	AllowVerify   bool   `json:"allowVerify"`
	AllowLocation bool   `json:"allowLocation"`
	MemberVerify  string `json:"memberVerify"`
	MemberPoints  string `json:"memberPoints"`
	SignFollow    bool   `json:"signFollow"`
}

type GlobalConfig struct {
	TelegramProxy string `json:"telegramProxy"`
}

type PluginConfig struct {
	Key         string         `json:"key"`
	Name        string         `json:"name"`
	Subtitle    string         `json:"subtitle"`
	Description string         `json:"description"`
	Category    string         `json:"category"`
	Enabled     bool           `json:"enabled"`
	UserEnabled bool           `json:"userEnabled"`
	Paid        bool           `json:"paid"`
	Price       string         `json:"price"`
	Sort        int            `json:"sort"`
	Settings    map[string]any `json:"settings"`
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
	if s.Plugins == nil {
		s.Plugins = map[string]*PluginConfig{}
	}
	for key, item := range DefaultPluginConfigs() {
		if _, ok := s.Plugins[key]; !ok {
			s.Plugins[key] = item
		}
	}
	if s.Settings == nil {
		s.Settings = &Settings{}
	}
	if s.Global == nil {
		s.Global = &GlobalConfig{}
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

func DefaultPluginConfigs() map[string]*PluginConfig {
	return map[string]*PluginConfig{
		"collector": {
			Key:         "collector",
			Name:        "采集插件",
			Subtitle:    "BangChat 绑定采集",
			Description: "支持快速采集、审核发布、笔记编号、验证视频和位置私聊解锁入口。",
			Category:    "采集",
			Enabled:     true,
			UserEnabled: true,
			Paid:        false,
			Price:       "0",
			Sort:        10,
			Settings: map[string]any{
				"autoPull":           false,
				"menuVisible":        true,
				"command":            "/pull",
				"commands":           []any{"/bind", "/bind_review", "/bind_publish", "/pull"},
				"defaultMode":        "quick",
				"showVerifyLink":     true,
				"showLocationLink":   true,
				"footer":             "",
				"bindHelpText":       "请发送 /bind <BangChat链接>。默认快速模式会把采集结果发送到当前群聊或频道；如需审核后发布，请发送 /bind_review <BangChat链接>。",
				"quickBindText":      "已进入快速采集模式，内容会直接发送到当前会话。发送 /pull 可立即采集。",
				"reviewBindText":     "已进入审核发布模式，内容会先发送到当前审核群。请在公开频道中发送 /绑定发布 后，再点击审核消息下方的发布按钮。",
				"publishBindText":    "发布频道绑定成功，审核群中的内容点击发布后会推送到当前频道。",
				"pullingText":        "开始采集，请稍候...",
				"verifyLinkText":     "📒 点击查看验证视频",
				"locationLinkText":   "📍 点击查看位置",
				"captionTemplate":    "<b>{title}</b>\n\n{text}\n\n编号：<code>{code}</code>\n\n{verify_link}\n{location_link}\n\n{footer}",
				"emptyFooterTipText": "当前未配置页脚。发送 /设置页脚 <内容> 可以设置每条笔记底部文案。",
			},
		},
		"welcome": {
			Key:         "welcome",
			Name:        "欢迎语插件",
			Subtitle:    "/start 入口欢迎语",
			Description: "首次关注与 /start 入口，可挂载底部菜单等插件能力。",
			Category:    "基础",
			Enabled:     true,
			UserEnabled: true,
			Paid:        false,
			Price:       "0",
			Sort:        15,
			Settings: map[string]any{
				"welcomeText":    "欢迎使用<b>懒羊羊TGGo</b>",
				"mountedPlugins": []any{"menu"},
				"mountMenu":      true,
			},
		},
		"menu": {
			Key:         "menu",
			Name:        "底部菜单插件",
			Subtitle:    "Reply Keyboard 按钮菜单",
			Description: "统一管理底部按钮布局，按钮可回复文本、打开链接或挂载插件功能。",
			Category:    "基础",
			Enabled:     true,
			UserEnabled: true,
			Paid:        false,
			Price:       "0",
			Sort:        16,
			Settings: map[string]any{
				"menuVisible": true,
				"buttons": []any{
					[]any{
						map[string]any{"text": "帮助", "action": "reply", "value": "请联系管理员获取帮助。"},
					},
				},
			},
		},
		"review": {
			Key:         "review",
			Name:        "审核插件",
			Subtitle:    "审核群操作按钮",
			Description: "审核群消息、审批通过、查看位置和查看验证按钮。",
			Category:    "审核",
			Enabled:     true,
			UserEnabled: true,
			Paid:        false,
			Price:       "0",
			Sort:        20,
			Settings:    map[string]any{"allowVerify": true, "allowLocation": true, "menuVisible": false, "command": "/review"},
		},
		"signin": {
			Key:         "signin",
			Name:        "签到插件",
			Subtitle:    "签到和关注校验",
			Description: "用户签到、关注频道校验和人机验证。",
			Category:    "增长",
			Enabled:     false,
			UserEnabled: true,
			Paid:        false,
			Price:       "0",
			Sort:        30,
			Settings:    map[string]any{"followRequired": false, "menuVisible": true, "command": "/sign", "commands": []any{"/sign"}},
		},
		"member": {
			Key:         "member",
			Name:        "会员积分插件",
			Subtitle:    "会员和积分体系",
			Description: "会员身份、积分解锁、积分记录和会员链接。",
			Category:    "变现",
			Enabled:     true,
			UserEnabled: false,
			Paid:        true,
			Price:       "99",
			Sort:        40,
			Settings:    map[string]any{"verifyMode": "none", "points": 0, "menuVisible": false, "command": "/member", "commands": []any{"/member"}},
		},
	}
}

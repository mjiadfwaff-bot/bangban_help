// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoBinding is the golang structure for table addon_lazysheep_tggo_binding.
type AddonLazysheepTggoBinding struct {
	Id              int         `json:"id"              orm:"id"               description:""`
	BindingKey      string      `json:"bindingKey"      orm:"binding_key"      description:""`
	BotId           int         `json:"botId"           orm:"bot_id"           description:""`
	BotKey          string      `json:"botKey"          orm:"bot_key"          description:""`
	SourceUrl       string      `json:"sourceUrl"       orm:"source_url"       description:""`
	SourceToken     string      `json:"sourceToken"     orm:"source_token"     description:""`
	SourceRoomId    int         `json:"sourceRoomId"    orm:"source_room_id"   description:""`
	SourcePairId    string      `json:"sourcePairId"    orm:"source_pair_id"   description:""`
	ReviewChatId    int         `json:"reviewChatId"    orm:"review_chat_id"   description:""`
	PublishChatId   int         `json:"publishChatId"   orm:"publish_chat_id"  description:""`
	AutoPush        int         `json:"autoPush"        orm:"auto_push"        description:""`
	ReviewEnabled   int         `json:"reviewEnabled"   orm:"review_enabled"   description:""`
	PublishEnabled  int         `json:"publishEnabled"  orm:"publish_enabled"  description:""`
	VerifyEnabled   int         `json:"verifyEnabled"   orm:"verify_enabled"   description:""`
	LocationEnabled int         `json:"locationEnabled" orm:"location_enabled" description:""`
	LastPullId      int         `json:"lastPullId"      orm:"last_pull_id"     description:""`
	LastCursor      string      `json:"lastCursor"      orm:"last_cursor"      description:""`
	Status          int         `json:"status"          orm:"status"           description:""`
	CreatedBy       int         `json:"createdBy"       orm:"created_by"       description:""`
	UpdatedBy       int         `json:"updatedBy"       orm:"updated_by"       description:""`
	CreatedAt       *gtime.Time `json:"createdAt"       orm:"created_at"       description:""`
	UpdatedAt       *gtime.Time `json:"updatedAt"       orm:"updated_at"       description:""`
}

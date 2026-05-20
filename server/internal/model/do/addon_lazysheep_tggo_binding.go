// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoBinding is the golang structure of table hg_addon_lazysheep_tggo_binding for DAO operations like Where/Data.
type AddonLazysheepTggoBinding struct {
	g.Meta          `orm:"table:hg_addon_lazysheep_tggo_binding, do:true"`
	Id              any         //
	BindingKey      any         //
	BotId           any         //
	BotKey          any         //
	SourceUrl       any         //
	SourceToken     any         //
	SourceRoomId    any         //
	SourcePairId    any         //
	ReviewChatId    any         //
	PublishChatId   any         //
	AutoPush        any         //
	ReviewEnabled   any         //
	PublishEnabled  any         //
	VerifyEnabled   any         //
	LocationEnabled any         //
	LastPullId      any         //
	LastCursor      any         //
	Status          any         //
	CreatedBy       any         //
	UpdatedBy       any         //
	CreatedAt       *gtime.Time //
	UpdatedAt       *gtime.Time //
}

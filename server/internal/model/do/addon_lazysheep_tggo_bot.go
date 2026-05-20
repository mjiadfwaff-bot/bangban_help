// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoBot is the golang structure of table hg_addon_lazysheep_tggo_bot for DAO operations like Where/Data.
type AddonLazysheepTggoBot struct {
	g.Meta        `orm:"table:hg_addon_lazysheep_tggo_bot, do:true"`
	Id            any         //
	BotKey        any         //
	MemberId      any         //
	Token         any         //
	BotName       any         //
	Username      any         //
	WebhookSecret any         //
	WebhookPath   any         //
	Enabled       any         //
	AutoPull      any         //
	AutoForward   any         //
	ReviewEnabled any         //
	AllowVerify   any         //
	AllowLocation any         //
	MemberVerify  any         //
	MemberPoints  any         //
	SignFollow    any         //
	SignChannels  *gjson.Json //
	ReviewText    any         //
	PublishText   any         //
	Sort          any         //
	Status        any         //
	CreatedBy     any         //
	UpdatedBy     any         //
	CreatedAt     *gtime.Time //
	UpdatedAt     *gtime.Time //
}

// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoUser is the golang structure of table hg_addon_lazysheep_tggo_user for DAO operations like Where/Data.
type AddonLazysheepTggoUser struct {
	g.Meta       `orm:"table:hg_addon_lazysheep_tggo_user, do:true"`
	Id           any         //
	TelegramId   any         //
	MemberId     any         //
	Username     any         //
	FirstName    any         //
	LastName     any         //
	LanguageCode any         //
	IsBot        any         //
	MemberLevel  any         //
	Points       any         //
	LastActiveAt *gtime.Time //
	Status       any         //
	CreatedAt    *gtime.Time //
	UpdatedAt    *gtime.Time //
}

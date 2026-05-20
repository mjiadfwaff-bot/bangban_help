// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoUser is the golang structure for table addon_lazysheep_tggo_user.
type AddonLazysheepTggoUser struct {
	Id           int         `json:"id"           orm:"id"             description:""`
	TelegramId   int         `json:"telegramId"   orm:"telegram_id"    description:""`
	MemberId     int         `json:"memberId"     orm:"member_id"      description:""`
	Username     string      `json:"username"     orm:"username"       description:""`
	FirstName    string      `json:"firstName"    orm:"first_name"     description:""`
	LastName     string      `json:"lastName"     orm:"last_name"      description:""`
	LanguageCode string      `json:"languageCode" orm:"language_code"  description:""`
	IsBot        int         `json:"isBot"        orm:"is_bot"         description:""`
	MemberLevel  int         `json:"memberLevel"  orm:"member_level"   description:""`
	Points       float64     `json:"points"       orm:"points"         description:""`
	LastActiveAt *gtime.Time `json:"lastActiveAt" orm:"last_active_at" description:""`
	Status       int         `json:"status"       orm:"status"         description:""`
	CreatedAt    *gtime.Time `json:"createdAt"    orm:"created_at"     description:""`
	UpdatedAt    *gtime.Time `json:"updatedAt"    orm:"updated_at"     description:""`
}

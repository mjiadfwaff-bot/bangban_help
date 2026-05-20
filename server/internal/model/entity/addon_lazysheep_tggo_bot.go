// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoBot is the golang structure for table addon_lazysheep_tggo_bot.
type AddonLazysheepTggoBot struct {
	Id            int         `json:"id"            orm:"id"             description:""`
	BotKey        string      `json:"botKey"        orm:"bot_key"        description:""`
	MemberId      int         `json:"memberId"      orm:"member_id"      description:""`
	Token         string      `json:"token"         orm:"token"          description:""`
	BotName       string      `json:"botName"       orm:"bot_name"       description:""`
	Username      string      `json:"username"      orm:"username"       description:""`
	WebhookSecret string      `json:"webhookSecret" orm:"webhook_secret" description:""`
	WebhookPath   string      `json:"webhookPath"   orm:"webhook_path"   description:""`
	Enabled       int         `json:"enabled"       orm:"enabled"        description:""`
	AutoPull      int         `json:"autoPull"      orm:"auto_pull"      description:""`
	AutoForward   int         `json:"autoForward"   orm:"auto_forward"   description:""`
	ReviewEnabled int         `json:"reviewEnabled" orm:"review_enabled" description:""`
	AllowVerify   int         `json:"allowVerify"   orm:"allow_verify"   description:""`
	AllowLocation int         `json:"allowLocation" orm:"allow_location" description:""`
	MemberVerify  int         `json:"memberVerify"  orm:"member_verify"  description:""`
	MemberPoints  int         `json:"memberPoints"  orm:"member_points"  description:""`
	SignFollow    int         `json:"signFollow"    orm:"sign_follow"    description:""`
	SignChannels  *gjson.Json `json:"signChannels"  orm:"sign_channels"  description:""`
	ReviewText    string      `json:"reviewText"    orm:"review_text"    description:""`
	PublishText   string      `json:"publishText"   orm:"publish_text"   description:""`
	Sort          int         `json:"sort"          orm:"sort"           description:""`
	Status        int         `json:"status"        orm:"status"         description:""`
	CreatedBy     int         `json:"createdBy"     orm:"created_by"     description:""`
	UpdatedBy     int         `json:"updatedBy"     orm:"updated_by"     description:""`
	CreatedAt     *gtime.Time `json:"createdAt"     orm:"created_at"     description:""`
	UpdatedAt     *gtime.Time `json:"updatedAt"     orm:"updated_at"     description:""`
}

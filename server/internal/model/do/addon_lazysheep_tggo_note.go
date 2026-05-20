// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoNote is the golang structure of table hg_addon_lazysheep_tggo_note for DAO operations like Where/Data.
type AddonLazysheepTggoNote struct {
	g.Meta           `orm:"table:hg_addon_lazysheep_tggo_note, do:true"`
	Id               any         //
	BotId            any         //
	BindingId        any         //
	ContentId        any         //
	UpId             any         //
	PairId           any         //
	ReceiverRoomId   any         //
	RoomName         any         //
	Sender           any         //
	SenderDno        any         //
	SenderUser       *gjson.Json //
	RawPayload       *gjson.Json //
	NotePayload      *gjson.Json //
	MessageType      any         //
	Code             any         //
	Title            any         //
	TextContent      any         //
	WorkflowStatus   any         //
	ReviewMessageId  any         //
	PublishMessageId any         //
	ApprovedBy       any         //
	PublishedBy      any         //
	ApprovedAt       *gtime.Time //
	PublishedAt      *gtime.Time //
	LastError        any         //
	Sort             any         //
	Status           any         //
	CreatedAt        *gtime.Time //
	UpdatedAt        *gtime.Time //
	DeletedAt        *gtime.Time //
}

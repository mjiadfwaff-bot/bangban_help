// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/encoding/gjson"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoNote is the golang structure for table addon_lazysheep_tggo_note.
type AddonLazysheepTggoNote struct {
	Id               int         `json:"id"               orm:"id"                 description:""`
	BotId            int         `json:"botId"            orm:"bot_id"             description:""`
	BindingId        int         `json:"bindingId"        orm:"binding_id"         description:""`
	ContentId        int         `json:"contentId"        orm:"content_id"         description:""`
	UpId             int         `json:"upId"             orm:"up_id"              description:""`
	PairId           string      `json:"pairId"           orm:"pair_id"            description:""`
	ReceiverRoomId   int         `json:"receiverRoomId"   orm:"receiver_room_id"   description:""`
	RoomName         string      `json:"roomName"         orm:"room_name"          description:""`
	Sender           string      `json:"sender"           orm:"sender"             description:""`
	SenderDno        string      `json:"senderDno"        orm:"sender_dno"         description:""`
	SenderUser       *gjson.Json `json:"senderUser"       orm:"sender_user"        description:""`
	RawPayload       *gjson.Json `json:"rawPayload"       orm:"raw_payload"        description:""`
	NotePayload      *gjson.Json `json:"notePayload"      orm:"note_payload"       description:""`
	MessageType      string      `json:"messageType"      orm:"message_type"       description:""`
	Code             string      `json:"code"             orm:"code"               description:""`
	Title            string      `json:"title"            orm:"title"              description:""`
	TextContent      string      `json:"textContent"      orm:"text_content"       description:""`
	WorkflowStatus   int         `json:"workflowStatus"   orm:"workflow_status"    description:""`
	ReviewMessageId  int         `json:"reviewMessageId"  orm:"review_message_id"  description:""`
	PublishMessageId int         `json:"publishMessageId" orm:"publish_message_id" description:""`
	ApprovedBy       int         `json:"approvedBy"       orm:"approved_by"        description:""`
	PublishedBy      int         `json:"publishedBy"      orm:"published_by"       description:""`
	ApprovedAt       *gtime.Time `json:"approvedAt"       orm:"approved_at"        description:""`
	PublishedAt      *gtime.Time `json:"publishedAt"      orm:"published_at"       description:""`
	LastError        string      `json:"lastError"        orm:"last_error"         description:""`
	Sort             int         `json:"sort"             orm:"sort"               description:""`
	Status           int         `json:"status"           orm:"status"             description:""`
	CreatedAt        *gtime.Time `json:"createdAt"        orm:"created_at"         description:""`
	UpdatedAt        *gtime.Time `json:"updatedAt"        orm:"updated_at"         description:""`
	DeletedAt        *gtime.Time `json:"deletedAt"        orm:"deleted_at"         description:""`
}

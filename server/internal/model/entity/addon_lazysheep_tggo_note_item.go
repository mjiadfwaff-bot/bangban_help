// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package entity

import (
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoNoteItem is the golang structure for table addon_lazysheep_tggo_note_item.
type AddonLazysheepTggoNoteItem struct {
	Id           int         `json:"id"           orm:"id"            description:""`
	NoteId       int         `json:"noteId"       orm:"note_id"       description:""`
	ItemIndex    int         `json:"itemIndex"    orm:"item_index"    description:""`
	ItemType     string      `json:"itemType"     orm:"item_type"     description:""`
	Title        string      `json:"title"        orm:"title"         description:""`
	SubTitle     string      `json:"subTitle"     orm:"sub_title"     description:""`
	Content      string      `json:"content"      orm:"content"       description:""`
	Duration     int         `json:"duration"     orm:"duration"      description:""`
	AspectRatio  float64     `json:"aspectRatio"  orm:"aspect_ratio"  description:""`
	VerifyVideo  int         `json:"verifyVideo"  orm:"verify_video"  description:""`
	AttachmentId int         `json:"attachmentId" orm:"attachment_id" description:""`
	PreviewUrl   string      `json:"previewUrl"   orm:"preview_url"   description:""`
	LocalPath    string      `json:"localPath"    orm:"local_path"    description:""`
	TgFileId     string      `json:"tgFileId"     orm:"tg_file_id"    description:""`
	Status       int         `json:"status"       orm:"status"        description:""`
	CreatedAt    *gtime.Time `json:"createdAt"    orm:"created_at"    description:""`
	UpdatedAt    *gtime.Time `json:"updatedAt"    orm:"updated_at"    description:""`
	DeletedAt    *gtime.Time `json:"deletedAt"    orm:"deleted_at"    description:""`
}

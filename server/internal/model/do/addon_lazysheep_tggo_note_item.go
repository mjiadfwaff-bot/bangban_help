// =================================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// =================================================================================

package do

import (
	"github.com/gogf/gf/v2/frame/g"
	"github.com/gogf/gf/v2/os/gtime"
)

// AddonLazysheepTggoNoteItem is the golang structure of table hg_addon_lazysheep_tggo_note_item for DAO operations like Where/Data.
type AddonLazysheepTggoNoteItem struct {
	g.Meta       `orm:"table:hg_addon_lazysheep_tggo_note_item, do:true"`
	Id           any         //
	NoteId       any         //
	ItemIndex    any         //
	ItemType     any         //
	Title        any         //
	SubTitle     any         //
	Content      any         //
	Duration     any         //
	AspectRatio  any         //
	VerifyVideo  any         //
	AttachmentId any         //
	PreviewUrl   any         //
	LocalPath    any         //
	TgFileId     any         //
	Status       any         //
	CreatedAt    *gtime.Time //
	UpdatedAt    *gtime.Time //
	DeletedAt    *gtime.Time //
}

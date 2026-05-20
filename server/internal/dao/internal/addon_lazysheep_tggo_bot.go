// ==========================================================================
// Code generated and maintained by GoFrame CLI tool. DO NOT EDIT.
// ==========================================================================

package internal

import (
	"context"

	"github.com/gogf/gf/v2/database/gdb"
	"github.com/gogf/gf/v2/frame/g"
)

// AddonLazysheepTggoBotDao is the data access object for the table hg_addon_lazysheep_tggo_bot.
type AddonLazysheepTggoBotDao struct {
	table    string                       // table is the underlying table name of the DAO.
	group    string                       // group is the database configuration group name of the current DAO.
	columns  AddonLazysheepTggoBotColumns // columns contains all the column names of Table for convenient usage.
	handlers []gdb.ModelHandler           // handlers for customized model modification.
}

// AddonLazysheepTggoBotColumns defines and stores column names for the table hg_addon_lazysheep_tggo_bot.
type AddonLazysheepTggoBotColumns struct {
	Id            string //
	BotKey        string //
	MemberId      string //
	Token         string //
	BotName       string //
	Username      string //
	WebhookSecret string //
	WebhookPath   string //
	Enabled       string //
	AutoPull      string //
	AutoForward   string //
	ReviewEnabled string //
	AllowVerify   string //
	AllowLocation string //
	MemberVerify  string //
	MemberPoints  string //
	SignFollow    string //
	SignChannels  string //
	ReviewText    string //
	PublishText   string //
	Sort          string //
	Status        string //
	CreatedBy     string //
	UpdatedBy     string //
	CreatedAt     string //
	UpdatedAt     string //
}

// addonLazysheepTggoBotColumns holds the columns for the table hg_addon_lazysheep_tggo_bot.
var addonLazysheepTggoBotColumns = AddonLazysheepTggoBotColumns{
	Id:            "id",
	BotKey:        "bot_key",
	MemberId:      "member_id",
	Token:         "token",
	BotName:       "bot_name",
	Username:      "username",
	WebhookSecret: "webhook_secret",
	WebhookPath:   "webhook_path",
	Enabled:       "enabled",
	AutoPull:      "auto_pull",
	AutoForward:   "auto_forward",
	ReviewEnabled: "review_enabled",
	AllowVerify:   "allow_verify",
	AllowLocation: "allow_location",
	MemberVerify:  "member_verify",
	MemberPoints:  "member_points",
	SignFollow:    "sign_follow",
	SignChannels:  "sign_channels",
	ReviewText:    "review_text",
	PublishText:   "publish_text",
	Sort:          "sort",
	Status:        "status",
	CreatedBy:     "created_by",
	UpdatedBy:     "updated_by",
	CreatedAt:     "created_at",
	UpdatedAt:     "updated_at",
}

// NewAddonLazysheepTggoBotDao creates and returns a new DAO object for table data access.
func NewAddonLazysheepTggoBotDao(handlers ...gdb.ModelHandler) *AddonLazysheepTggoBotDao {
	return &AddonLazysheepTggoBotDao{
		group:    "default",
		table:    "hg_addon_lazysheep_tggo_bot",
		columns:  addonLazysheepTggoBotColumns,
		handlers: handlers,
	}
}

// DB retrieves and returns the underlying raw database management object of the current DAO.
func (dao *AddonLazysheepTggoBotDao) DB() gdb.DB {
	return g.DB(dao.group)
}

// Table returns the table name of the current DAO.
func (dao *AddonLazysheepTggoBotDao) Table() string {
	return dao.table
}

// Columns returns all column names of the current DAO.
func (dao *AddonLazysheepTggoBotDao) Columns() AddonLazysheepTggoBotColumns {
	return dao.columns
}

// Group returns the database configuration group name of the current DAO.
func (dao *AddonLazysheepTggoBotDao) Group() string {
	return dao.group
}

// Ctx creates and returns a Model for the current DAO. It automatically sets the context for the current operation.
func (dao *AddonLazysheepTggoBotDao) Ctx(ctx context.Context) *gdb.Model {
	model := dao.DB().Model(dao.table)
	for _, handler := range dao.handlers {
		model = handler(model)
	}
	return model.Safe().Ctx(ctx)
}

// Transaction wraps the transaction logic using function f.
// It rolls back the transaction and returns the error if function f returns a non-nil error.
// It commits the transaction and returns nil if function f returns nil.
//
// Note: Do not commit or roll back the transaction in function f,
// as it is automatically handled by this function.
func (dao *AddonLazysheepTggoBotDao) Transaction(ctx context.Context, f func(ctx context.Context, tx gdb.TX) error) (err error) {
	return dao.Ctx(ctx).Transaction(ctx, f)
}

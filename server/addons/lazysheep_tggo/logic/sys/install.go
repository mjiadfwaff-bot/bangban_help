// Package sys
// @Link  https://github.com/bufanyun/hotgo
// @Copyright  Copyright (c) 2023 HotGo CLI
// @Author  Codex
// @License  https://github.com/bufanyun/hotgo/blob/master/LICENSE
package sys

import (
	"context"
	"path/filepath"
	"strings"

	"github.com/gogf/gf/v2/errors/gerror"
	"github.com/gogf/gf/v2/frame/g"
	"hotgo/internal/consts"
	"hotgo/internal/library/dbinit"
)

func (s *sLazySheepTGGo) ensureTables(ctx context.Context) error {
	if err := s.ensureAddonsConfigValue(ctx); err != nil {
		return err
	}
	if err := s.ensureUserBotKey(ctx); err != nil {
		return err
	}
	if err := s.ensureNoteTables(ctx); err != nil {
		return err
	}
	if err := s.ensureWebhookLogTable(ctx); err != nil {
		return err
	}
	ok, err := dbinit.HasTable(ctx, "hg_addon_lazysheep_tggo_bot")
	if err != nil {
		return gerror.Wrap(err, "检查懒羊羊TGGo数据表失败")
	}
	if ok {
		return nil
	}
	sqlPath, err := lazySheepSQLPath(ctx)
	if err != nil {
		return err
	}
	if err = dbinit.ImportFile(ctx, sqlPath); err != nil {
		return gerror.Wrap(err, "初始化懒羊羊TGGo数据表失败")
	}
	return nil
}

func (s *sLazySheepTGGo) ensureNoteTables(ctx context.Context) error {
	if ok, err := dbinit.HasTable(ctx, "hg_addon_lazysheep_tggo_note"); err != nil || !ok {
		return err
	}
	switch g.DB().GetConfig().Type {
	case consts.DBPgsql:
		if _, err := g.DB().Exec(ctx, "DROP INDEX IF EXISTS hg_addon_lazysheep_tggo_note_content_id"); err != nil {
			return gerror.Wrap(err, "删除旧笔记索引失败")
		}
		if _, err := g.DB().Exec(ctx, "CREATE UNIQUE INDEX IF NOT EXISTS hg_addon_lazysheep_tggo_note_bot_content_id ON hg_addon_lazysheep_tggo_note (bot_id, content_id)"); err != nil {
			return gerror.Wrap(err, "创建笔记内容索引失败")
		}
		if _, err := g.DB().Exec(ctx, "CREATE UNIQUE INDEX IF NOT EXISTS hg_addon_lazysheep_tggo_note_bot_code ON hg_addon_lazysheep_tggo_note (bot_id, code)"); err != nil {
			return gerror.Wrap(err, "创建笔记编号索引失败")
		}
	case consts.DBMysql, "":
		if ok, err := mysqlHasIndex(ctx, "hg_addon_lazysheep_tggo_note", "content_id"); err != nil {
			return gerror.Wrap(err, "检查旧笔记索引失败")
		} else if ok {
			if _, err = g.DB().Exec(ctx, "ALTER TABLE `hg_addon_lazysheep_tggo_note` DROP INDEX `content_id`"); err != nil {
				return gerror.Wrap(err, "删除旧笔记索引失败")
			}
		}
		if ok, err := mysqlHasIndex(ctx, "hg_addon_lazysheep_tggo_note", "bot_content_id"); err != nil {
			return gerror.Wrap(err, "检查笔记内容索引失败")
		} else if !ok {
			if _, err = g.DB().Exec(ctx, "ALTER TABLE `hg_addon_lazysheep_tggo_note` ADD UNIQUE KEY `bot_content_id` (`bot_id`,`content_id`)"); err != nil {
				return gerror.Wrap(err, "创建笔记内容索引失败")
			}
		}
		if ok, err := mysqlHasIndex(ctx, "hg_addon_lazysheep_tggo_note", "bot_code"); err != nil {
			return gerror.Wrap(err, "检查笔记编号索引失败")
		} else if !ok {
			if _, err = g.DB().Exec(ctx, "ALTER TABLE `hg_addon_lazysheep_tggo_note` ADD UNIQUE KEY `bot_code` (`bot_id`,`code`)"); err != nil {
				return gerror.Wrap(err, "创建笔记编号索引失败")
			}
		}
	default:
		return nil
	}
	sqlPath, err := lazySheepSQLPath(ctx)
	if err != nil {
		return err
	}
	if err = dbinit.ImportFile(ctx, sqlPath); err != nil {
		return gerror.Wrap(err, "初始化笔记资源表失败")
	}
	return nil
}

func (s *sLazySheepTGGo) ensureWebhookLogTable(ctx context.Context) error {
	if ok, err := dbinit.HasTable(ctx, "hg_addon_lazysheep_tggo_webhook_log"); err != nil || ok {
		return err
	}
	switch g.DB().GetConfig().Type {
	case consts.DBPgsql:
		_, err := g.DB().Exec(ctx, `
			CREATE TABLE IF NOT EXISTS hg_addon_lazysheep_tggo_webhook_log (
				id BIGSERIAL PRIMARY KEY,
				bot_key VARCHAR(64) NOT NULL DEFAULT '',
				update_id BIGINT NOT NULL DEFAULT 0,
				update_type VARCHAR(32) NOT NULL DEFAULT '',
				chat_id BIGINT NOT NULL DEFAULT 0,
				user_id BIGINT NOT NULL DEFAULT 0,
				username VARCHAR(128) NOT NULL DEFAULT '',
				message_id BIGINT NOT NULL DEFAULT 0,
				summary VARCHAR(512) NOT NULL DEFAULT '',
				payload TEXT,
				created_at TIMESTAMP NULL,
				updated_at TIMESTAMP NULL
			)
		`)
		return err
	case consts.DBMysql, "":
		_, err := g.DB().Exec(ctx, "CREATE TABLE IF NOT EXISTS `hg_addon_lazysheep_tggo_webhook_log` ("+
			"`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,"+
			"`bot_key` VARCHAR(64) NOT NULL DEFAULT '' COMMENT '机器人标识',"+
			"`update_id` BIGINT NOT NULL DEFAULT 0 COMMENT 'Telegram update id',"+
			"`update_type` VARCHAR(32) NOT NULL DEFAULT '' COMMENT '更新类型',"+
			"`chat_id` BIGINT NOT NULL DEFAULT 0 COMMENT '聊天ID',"+
			"`user_id` BIGINT NOT NULL DEFAULT 0 COMMENT '用户ID',"+
			"`username` VARCHAR(128) NOT NULL DEFAULT '' COMMENT '用户名',"+
			"`message_id` BIGINT NOT NULL DEFAULT 0 COMMENT '消息ID',"+
			"`summary` VARCHAR(512) NOT NULL DEFAULT '' COMMENT '摘要',"+
			"`payload` LONGTEXT COMMENT '原始内容',"+
			"`created_at` DATETIME DEFAULT NULL,`updated_at` DATETIME DEFAULT NULL,"+
			"PRIMARY KEY (`id`),"+
			"KEY `bot_update_id` (`bot_key`,`update_id`),"+
			"KEY `bot_chat_id` (`bot_key`,`chat_id`),"+
			"KEY `created_at` (`created_at`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='TG webhook原始日志'")
		return err
	default:
		return nil
	}
}

func (s *sLazySheepTGGo) ensureUserBotKey(ctx context.Context) error {
	if ok, err := dbinit.HasTable(ctx, "hg_addon_lazysheep_tggo_user"); err != nil || !ok {
		return err
	}
	hasField, err := tableHasField(ctx, "hg_addon_lazysheep_tggo_user", "bot_key")
	if err != nil {
		return gerror.Wrap(err, "检查TG用户机器人字段失败")
	}
	if hasField {
		return s.ensureUserUniqueIndex(ctx)
	}
	var sql string
	switch g.DB().GetConfig().Type {
	case consts.DBPgsql:
		sql = "ALTER TABLE hg_addon_lazysheep_tggo_user ADD COLUMN IF NOT EXISTS bot_key varchar(64) DEFAULT ''"
	case consts.DBMysql, "":
		sql = "ALTER TABLE `hg_addon_lazysheep_tggo_user` ADD COLUMN `bot_key` varchar(64) DEFAULT '' COMMENT '机器人标识' AFTER `telegram_id`"
	default:
		return nil
	}
	if _, err := g.DB().Exec(ctx, sql); err != nil {
		if strings.Contains(strings.ToLower(err.Error()), "duplicate column") {
			return s.ensureUserUniqueIndex(ctx)
		}
		return gerror.Wrap(err, "更新TG用户机器人字段失败")
	}
	return s.ensureUserUniqueIndex(ctx)
}

func (s *sLazySheepTGGo) ensureUserUniqueIndex(ctx context.Context) error {
	switch g.DB().GetConfig().Type {
	case consts.DBPgsql:
		_, _ = g.DB().Exec(ctx, "DROP INDEX IF EXISTS hg_addon_lazysheep_tggo_user_telegram_id")
		_, err := g.DB().Exec(ctx, "CREATE UNIQUE INDEX IF NOT EXISTS hg_addon_lazysheep_tggo_user_bot_telegram_id ON hg_addon_lazysheep_tggo_user (bot_key, telegram_id)")
		return err
	case consts.DBMysql, "":
		if ok, err := mysqlHasIndex(ctx, "hg_addon_lazysheep_tggo_user", "bot_telegram_id"); err != nil {
			return gerror.Wrap(err, "检查TG用户联合索引失败")
		} else if ok {
			return nil
		}
		if ok, err := mysqlHasIndex(ctx, "hg_addon_lazysheep_tggo_user", "telegram_id"); err != nil {
			return gerror.Wrap(err, "检查TG用户旧索引失败")
		} else if ok {
			if _, err = g.DB().Exec(ctx, "ALTER TABLE `hg_addon_lazysheep_tggo_user` DROP INDEX `telegram_id`"); err != nil {
				return gerror.Wrap(err, "删除TG用户旧索引失败")
			}
		}
		_, err := g.DB().Exec(ctx, "ALTER TABLE `hg_addon_lazysheep_tggo_user` ADD UNIQUE KEY `bot_telegram_id` (`bot_key`,`telegram_id`)")
		if err != nil && strings.Contains(strings.ToLower(err.Error()), "duplicate key name") {
			return nil
		}
		if err != nil && strings.Contains(strings.ToLower(err.Error()), "duplicate entry") {
			return nil
		}
		return err
	default:
		return nil
	}
}

func tableHasField(ctx context.Context, table, field string) (bool, error) {
	fields, err := g.DB().TableFields(ctx, table)
	if err != nil {
		return false, err
	}
	for name := range fields {
		if strings.EqualFold(name, field) {
			return true, nil
		}
	}
	return false, nil
}

func mysqlHasIndex(ctx context.Context, table, index string) (bool, error) {
	count, err := g.DB().GetCount(ctx, `
		SELECT COUNT(*) FROM information_schema.statistics
		WHERE table_schema = DATABASE() AND table_name = ? AND index_name = ?
	`, table, index)
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

func (s *sLazySheepTGGo) ensureAddonsConfigValue(ctx context.Context) error {
	var sql string
	switch g.DB().GetConfig().Type {
	case consts.DBPgsql:
		sql = "ALTER TABLE hg_sys_addons_config ALTER COLUMN value TYPE TEXT"
	case consts.DBMysql, "":
		sql = "ALTER TABLE `hg_sys_addons_config` MODIFY COLUMN `value` LONGTEXT COMMENT '参数键值'"
	default:
		return nil
	}
	if _, err := g.DB().Exec(ctx, sql); err != nil {
		return gerror.Wrap(err, "更新插件配置字段失败")
	}
	return nil
}

func lazySheepSQLPath(ctx context.Context) (string, error) {
	switch g.DB().GetConfig().Type {
	case consts.DBPgsql:
		return filepath.Join("storage", "data", "generate", "addons", "lazysheep_tggo_pgsql.sql"), nil
	case consts.DBMysql, "":
		return filepath.Join("storage", "data", "generate", "addons", "lazysheep_tggo_mysql.sql"), nil
	default:
		return "", gerror.Newf("懒羊羊TGGo暂不支持当前数据库类型自动初始化：%s", g.DB().GetConfig().Type)
	}
}

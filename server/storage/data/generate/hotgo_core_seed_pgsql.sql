-- HotGo minimal core seed for local development.
-- Keeps admin login/permissions usable without importing demo business rows.

INSERT INTO hg_admin_dept (id, pid, name, code, type, leader, phone, email, level, tree, sort, status, created_at, updated_at) VALUES
(100, 0, 'hotgo', 'hotgo', 'company', 'admin', '', '', 1, '', 10, 1, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO hg_admin_post (id, code, name, remark, sort, status, created_at, updated_at) VALUES
(1, 'admin', '管理员', '', 1, 1, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO hg_admin_role (id, name, key, data_scope, custom_dept, pid, level, tree, remark, sort, status, created_at, updated_at) VALUES
(1, '超级管理员', 'super', 1, '[]', 0, 1, NULL, '超级管理员，拥有全部权限', 100, 1, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO hg_admin_member_role (member_id, role_id) VALUES
(1, 1)
ON CONFLICT DO NOTHING;

INSERT INTO hg_admin_member_post (member_id, post_id) VALUES
(1, 1)
ON CONFLICT DO NOTHING;

INSERT INTO hg_sys_serve_license (id, "group", name, appid, secret_key, remote_addr, online_limit, login_times, last_login_at, last_active_at, routes, allowed_ips, end_at, remark, status, created_at, updated_at) VALUES
(1, 'cron', '本地开发定时任务客户端', '1002', 'hotgo', '127.0.0.1', 8, 0, NULL, NULL, NULL, '*', '2099-12-31 23:59:59', '本地开发环境自动初始化授权', 1, NOW(), NOW()),
(2, 'auth', '本地开发授权客户端', 'mengshuai', '123456', '127.0.0.1', 8, 0, NULL, NULL, NULL, '*', '2099-12-31 23:59:59', '本地开发环境自动初始化授权', 1, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

INSERT INTO hg_admin_menu (id, pid, level, tree, title, name, path, icon, type, redirect, permissions, permission_name, component, always_show, active_menu, is_root, is_frame, frame_src, keep_alive, hidden, affix, sort, remark, status, updated_at, created_at) VALUES
(2047, 0, 1, '', 'Dashboard', 'Dashboard', '/dashboard', 'DashboardOutlined', 1, '/dashboard/console', 'dashboard', '控制台', 'LAYOUT', 0, '', 0, 1, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2048, 2047, 2, 'tr_2047 ', '主控台', 'dashboard_console', 'console', '', 2, '', '/console/stat', '主控台', '/dashboard/console/console', 0, '', 0, 1, '', 0, 0, 0, 20, '', 1, NOW(), NOW()),
(2061, 0, 1, '', '组织管理', 'Org', '/org', 'AppstoreOutlined', 1, '/org/user', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 20, '', 1, NOW(), NOW()),
(2062, 2061, 2, 'tr_2061 ', '后台用户', 'user', 'user', '', 2, '', '/dept/list,/post/list,/role/list,/member/list,/dept/option', '', '/org/user/user', 0, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2063, 2061, 2, 'tr_2061 ', '部门管理', 'org_dept', 'dept', '', 2, '', '', '', '/org/dept/dept', 0, '', 0, 0, '', 1, 0, 0, 20, '', 1, NOW(), NOW()),
(2064, 2061, 2, 'tr_2061 ', '岗位管理', 'org_post', 'post', '', 2, '', '/post/list', '', '/org/post/post', 0, '', 0, 0, '', 1, 0, 0, 30, '', 1, NOW(), NOW()),
(2065, 0, 1, '', '权限管理', 'Permission', '/permission', 'SafetyCertificateOutlined', 1, '/permission/menu', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 40, '', 1, NOW(), NOW()),
(2066, 2065, 2, 'tr_2065 ', '菜单权限', 'permission_menu', 'menu', '', 2, '', '/menu/list', '', '/permission/menu/menu', 0, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2067, 2065, 2, 'tr_2065 ', '角色权限', 'permission_role', 'role', '', 2, '', '/role/list,/role/dataScope/select,/role/getPermissions', '', '/permission/role/role', 0, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2068, 0, 1, '', '系统设置', 'System', '/system', 'SettingOutlined', 1, '/system/config', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 120, '', 1, NOW(), NOW()),
(2069, 2068, 2, 'tr_2068 ', '配置管理', 'system_config', 'config', '', 2, '', '', '', '/system/config/system', 0, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2070, 2068, 2, 'tr_2068 ', '字典管理', 'system_dict', 'dict', '', 2, '', '', '', '/system/dict/index', 1, '', 0, 0, '', 0, 0, 0, 20, '', 1, NOW(), NOW()),
(2071, 2068, 2, 'tr_2068 ', '定时任务', 'system_cron', 'cron', '', 2, '', '', '', '/system/cron/index', 1, '', 0, 0, '', 0, 0, 0, 30, '', 1, NOW(), NOW()),
(2072, 2068, 2, 'tr_2068 ', '黑名单', 'system_blacklist', 'blacklist', '', 2, '', '', '', '/system/blacklist/index', 1, '', 0, 0, '', 0, 0, 0, 40, '', 1, NOW(), NOW()),
(2090, 0, 1, '', '系统监控', 'Monitors', '/monitor', 'FundProjectionScreenOutlined', 1, '', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 110, '', 1, NOW(), NOW()),
(2091, 2090, 2, 'tr_2090 ', '在线用户', 'monitor_online', 'online', '', 2, '', '/monitor/userOnlineList', '', '/monitor/online/index', 1, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2092, 2090, 2, 'tr_2090 ', '服务监控', 'monitor_serve_monitor', 'serve_monitor', '', 2, '', '', '', '/monitor/serve-monitor/index', 1, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2093, 0, 1, '', '系统应用', 'Applys', '/apply', 'CodeSandboxOutlined', 1, '/apply/attachment', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 100, '', 1, NOW(), NOW()),
(2095, 2093, 2, 'tr_2093 ', '附件管理', 'apply_attachment', 'attachment', '', 2, '', '/attachment/list', '', '/apply/attachment/index', 1, '', 0, 0, '', 0, 0, 0, 200, '', 1, NOW(), NOW()),
(2097, 0, 1, '', '开发工具', 'Develops', '/develop', 'CodeOutlined', 1, '/develop/code', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 210, '', 1, NOW(), NOW()),
(2098, 2097, 2, 'tr_2097 ', '代码生成', 'develop_code', 'code', '', 2, '', '/genCodes/list,/genCodes/selects,/genCodes/tableSelect', '', '/develop/code/index', 1, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(2229, 2097, 2, 'tr_2097 ', '插件管理', 'develop_addons', 'addons', '', 2, '', '/addons/selects,/addons/list,/addons/install,/addons/upgrade,/addons/uninstall,/addons/enable,/addons/disable', '', '/develop/addons/index', 1, '', 0, 0, '', 0, 0, 0, 20, '', 1, NOW(), NOW()),
(3000, 0, 1, '', '插件应用', 'Addons', '/addons', 'AppstoreOutlined', 1, '/addons/lazysheep_tggo/bot', '', '', 'LAYOUT', 1, '', 0, 0, '', 0, 0, 0, 90, '', 1, NOW(), NOW()),
(3001, 3000, 2, 'tr_3000 ', '懒羊羊TGGo', 'addons_lazysheep_tggo', 'lazysheep_tggo', '', 1, '/addons/lazysheep_tggo/bot', '', '', 'ParentLayout', 1, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(3002, 3001, 3, 'tr_3000 tr_3001 ', '机器人管理', 'addons_lazysheep_tggo_bot', 'bot', '', 2, '', '/lazysheep_tggo/config/get,/lazysheep_tggo/config/update,/lazysheep_tggo/config/deleteBot,/lazysheep_tggo/config/startBot,/lazysheep_tggo/config/botUsers,/lazysheep_tggo/config/updateBotUser', '', '/addons/lazysheep_tggo/bot/index', 0, '', 0, 0, '', 0, 0, 0, 10, '', 1, NOW(), NOW()),
(3003, 3001, 3, 'tr_3000 tr_3001 ', '插件配置', 'addons_lazysheep_tggo_config', 'config', '', 2, '', '/lazysheep_tggo/config/get,/lazysheep_tggo/config/update', '', '/addons/lazysheep_tggo/config/system', 0, '', 0, 0, '', 0, 0, 0, 20, '', 1, NOW(), NOW()),
(3004, 3001, 3, 'tr_3000 tr_3001 ', '全局配置', 'addons_lazysheep_tggo_global', 'global', '', 2, '', '', '', '/addons/lazysheep_tggo/global/index', 0, '', 0, 0, '', 0, 0, 0, 30, '', 1, NOW(), NOW()),
(3005, 3001, 3, 'tr_3000 tr_3001 ', '拉取监控', 'addons_lazysheep_tggo_pull_monitor', 'pull-monitor', '', 2, '', '/lazysheep_tggo/config/pullMonitor', '', '/addons/lazysheep_tggo/config/pull-monitor', 0, '', 0, 0, '', 0, 0, 0, 40, '', 1, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

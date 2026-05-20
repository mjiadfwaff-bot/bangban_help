-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: 2024-08-27 19:04:42
-- 服务器版本： 5.7.37-log
-- PHP Version: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hotgo`
--

-- --------------------------------------------------------

--
-- 表的结构 `hg_addon_hgexample_table`
--

CREATE TABLE IF NOT EXISTS `hg_addon_hgexample_table` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `pid` bigint(20) DEFAULT '0' COMMENT '上级ID',
  `level` int(11) DEFAULT '1' COMMENT '树等级',
  `tree` varchar(512) DEFAULT NULL COMMENT '关系树',
  `category_id` bigint(20) DEFAULT NULL COMMENT '分类ID',
  `flag` json DEFAULT NULL COMMENT '标签',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `content` longtext COMMENT '内容',
  `image` varchar(255) DEFAULT NULL COMMENT '单图',
  `images` json DEFAULT NULL COMMENT '多图',
  `attachfile` varchar(255) DEFAULT NULL COMMENT '附件',
  `attachfiles` json DEFAULT NULL COMMENT '多附件',
  `map` json DEFAULT NULL COMMENT '动态键值对',
  `star` decimal(5,1) DEFAULT '0.0' COMMENT '推荐星',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `views` bigint(20) DEFAULT NULL COMMENT '浏览次数',
  `activity_at` date DEFAULT NULL COMMENT '活动时间',
  `start_at` datetime DEFAULT NULL COMMENT '开启时间',
  `end_at` datetime DEFAULT NULL COMMENT '结束时间',
  `switch` tinyint(1) DEFAULT NULL COMMENT '开关',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `avatar` varchar(255) DEFAULT '' COMMENT '头像',
  `sex` tinyint(1) DEFAULT NULL COMMENT '性别',
  `qq` varchar(20) DEFAULT '' COMMENT 'qq',
  `email` varchar(60) DEFAULT '' COMMENT '邮箱',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号码',
  `hobby` json DEFAULT NULL COMMENT '爱好',
  `channel` int(11) DEFAULT '1' COMMENT '渠道',
  `city_id` bigint(20) DEFAULT '0' COMMENT '所在城市',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_by` bigint(20) DEFAULT '0' COMMENT '创建者',
  `updated_by` bigint(20) DEFAULT '0' COMMENT '更新者',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间'
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='插件_案例_表格';

--
-- 转存表中的数据 `hg_addon_hgexample_table`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_addon_hgexample_tenant_order`
--

CREATE TABLE IF NOT EXISTS `hg_addon_hgexample_tenant_order` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户ID',
  `merchant_id` bigint(20) NOT NULL COMMENT '商户ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `product_name` varchar(255) DEFAULT NULL COMMENT '购买产品',
  `order_sn` varchar(64) DEFAULT NULL COMMENT '订单号',
  `money` decimal(10,2) NOT NULL COMMENT '充值金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint(4) DEFAULT '1' COMMENT '订单状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='多租户_充值订单';

--
-- 转存表中的数据 `hg_addon_hgexample_tenant_order`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_cash`
--

CREATE TABLE IF NOT EXISTS `hg_admin_cash` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `member_id` bigint(20) NOT NULL COMMENT '管理员ID',
  `money` decimal(10,2) NOT NULL COMMENT '提现金额',
  `fee` decimal(10,2) NOT NULL COMMENT '手续费',
  `last_money` decimal(10,2) NOT NULL COMMENT '最终到账金额',
  `ip` varchar(128) NOT NULL COMMENT '申请人IP',
  `status` bigint(20) NOT NULL COMMENT '状态码',
  `msg` varchar(128) DEFAULT NULL COMMENT '处理结果',
  `handle_at` datetime DEFAULT NULL COMMENT '处理时间',
  `created_at` datetime NOT NULL COMMENT '申请时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_提现记录表';

--
-- 转存表中的数据 `hg_admin_cash`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_credits_log`
--

CREATE TABLE IF NOT EXISTS `hg_admin_credits_log` (
  `id` bigint(20) NOT NULL COMMENT '变动ID',
  `member_id` bigint(20) DEFAULT '0' COMMENT '管理员ID',
  `app_id` varchar(64) DEFAULT NULL COMMENT '应用id',
  `addons_name` varchar(100) NOT NULL DEFAULT '' COMMENT '插件名称',
  `credit_type` varchar(32) NOT NULL DEFAULT '' COMMENT '变动类型',
  `credit_group` varchar(32) DEFAULT NULL COMMENT '变动组别',
  `before_num` decimal(10,2) DEFAULT '0.00' COMMENT '变动前',
  `num` decimal(10,2) DEFAULT '0.00' COMMENT '变动数据',
  `after_num` decimal(10,2) DEFAULT '0.00' COMMENT '变动后',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `ip` varchar(20) DEFAULT NULL COMMENT '操作人IP',
  `map_id` bigint(20) DEFAULT '0' COMMENT '关联ID',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_资产变动表';

--
-- 转存表中的数据 `hg_admin_credits_log`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_dept`
--

CREATE TABLE IF NOT EXISTS `hg_admin_dept` (
  `id` bigint(20) NOT NULL COMMENT '部门ID',
  `pid` bigint(20) DEFAULT '0' COMMENT '父部门ID',
  `name` varchar(32) DEFAULT NULL COMMENT '部门名称',
  `code` varchar(255) DEFAULT NULL COMMENT '部门编码',
  `type` varchar(10) DEFAULT NULL COMMENT '部门类型',
  `leader` varchar(32) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(64) DEFAULT NULL COMMENT '邮箱',
  `level` int(11) NOT NULL COMMENT '关系树等级',
  `tree` varchar(512) DEFAULT NULL COMMENT '关系树',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '部门状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_部门';

--
-- 转存表中的数据 `hg_admin_dept`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_member`
--

CREATE TABLE IF NOT EXISTS `hg_admin_member` (
  `id` bigint(20) NOT NULL COMMENT '管理员ID',
  `dept_id` bigint(20) DEFAULT '0' COMMENT '部门ID',
  `role_id` bigint(20) DEFAULT '10' COMMENT '角色ID',
  `real_name` varchar(32) DEFAULT '' COMMENT '真实姓名',
  `username` varchar(20) NOT NULL DEFAULT '' COMMENT '帐号',
  `password_hash` char(32) NOT NULL DEFAULT '' COMMENT '密码',
  `salt` char(16) NOT NULL COMMENT '密码盐',
  `password_reset_token` varchar(150) DEFAULT '' COMMENT '密码重置令牌',
  `integral` decimal(10,2) unsigned DEFAULT '0.00' COMMENT '积分',
  `balance` decimal(10,2) unsigned DEFAULT '0.00' COMMENT '余额',
  `avatar` char(150) DEFAULT '' COMMENT '头像',
  `sex` tinyint(1) DEFAULT '1' COMMENT '性别',
  `qq` varchar(20) DEFAULT '' COMMENT 'qq',
  `email` varchar(60) DEFAULT '' COMMENT '邮箱',
  `mobile` varchar(20) DEFAULT '' COMMENT '手机号码',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `city_id` bigint(20) DEFAULT '0' COMMENT '城市编码',
  `address` varchar(100) DEFAULT '' COMMENT '联系地址',
  `pid` bigint(20) NOT NULL COMMENT '上级管理员ID',
  `level` int(11) DEFAULT '1' COMMENT '关系树等级',
  `tree` varchar(512) NOT NULL COMMENT '关系树',
  `invite_code` varchar(12) DEFAULT NULL COMMENT '邀请码',
  `cash` json DEFAULT NULL COMMENT '提现配置',
  `last_active_at` datetime DEFAULT NULL COMMENT '最后活跃时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_用户表';

--
-- 转存表中的数据 `hg_admin_member`
--

INSERT INTO `hg_admin_member` (`id`, `dept_id`, `role_id`, `real_name`, `username`, `password_hash`, `salt`, `password_reset_token`, `integral`, `balance`, `avatar`, `sex`, `qq`, `email`, `mobile`, `birthday`, `city_id`, `address`, `pid`, `level`, `tree`, `invite_code`, `cash`, `last_active_at`, `remark`, `status`, `created_at`, `updated_at`) VALUES
(1, 100, 1, '孟帅', 'admin', 'a7c588fffeb2c1d99b29879d7fe97c78', '6541561', '', '88.00', '99289.78', 'https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8er9nfkchdopav.png', 1, '133814250', '133814250@qq.com', '15303830571', '2016-04-16', 410172, '莲花街001号', 0, 1, '', '111', '{"name": "孟帅", "account": "15303830571", "payeeCode": "https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8mqal5isvcb58g.jpg"}', '2024-08-27 19:02:49', NULL, 1, '2021-02-12 17:59:45', '2024-08-27 19:02:49');

-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_member_post`
--

CREATE TABLE IF NOT EXISTS `hg_admin_member_post` (
  `member_id` bigint(20) NOT NULL COMMENT '管理员ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员_用户岗位关联';

--
-- 转存表中的数据 `hg_admin_member_post`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_member_role`
--

CREATE TABLE IF NOT EXISTS `hg_admin_member_role` (
  `member_id` bigint(20) NOT NULL COMMENT '管理员ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员_用户角色关联';

--
-- 转存表中的数据 `hg_admin_member_role`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_menu`
--

CREATE TABLE IF NOT EXISTS `hg_admin_menu` (
  `id` bigint(20) NOT NULL COMMENT '菜单ID',
  `pid` bigint(20) DEFAULT '0' COMMENT '父菜单ID',
  `level` int(11) NOT NULL DEFAULT '1' COMMENT '关系树等级',
  `tree` varchar(255) DEFAULT NULL COMMENT '关系树',
  `title` varchar(64) NOT NULL COMMENT '菜单名称',
  `name` varchar(128) NOT NULL COMMENT '名称编码',
  `path` varchar(200) DEFAULT NULL COMMENT '路由地址',
  `icon` varchar(128) DEFAULT NULL COMMENT '菜单图标',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '菜单类型（1目录 2菜单 3按钮）',
  `redirect` varchar(255) DEFAULT NULL COMMENT '重定向地址',
  `permissions` varchar(512) DEFAULT NULL COMMENT '菜单包含权限集合',
  `permission_name` varchar(64) DEFAULT NULL COMMENT '权限名称',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `always_show` tinyint(1) DEFAULT '0' COMMENT '取消自动计算根路由模式',
  `active_menu` varchar(255) DEFAULT NULL COMMENT '高亮菜单编码',
  `is_root` tinyint(1) DEFAULT '0' COMMENT '是否跟路由',
  `is_frame` tinyint(1) DEFAULT '1' COMMENT '是否内嵌',
  `frame_src` varchar(512) DEFAULT NULL COMMENT '内联外部地址',
  `keep_alive` tinyint(1) DEFAULT '0' COMMENT '缓存该路由',
  `hidden` tinyint(1) DEFAULT '0' COMMENT '是否隐藏',
  `affix` tinyint(1) DEFAULT '0' COMMENT '是否固定',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '菜单状态',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB AUTO_INCREMENT=2431 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_菜单权限';

--
-- 转存表中的数据 `hg_admin_menu`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_notice`
--

CREATE TABLE IF NOT EXISTS `hg_admin_notice` (
  `id` bigint(20) NOT NULL COMMENT '公告ID',
  `title` varchar(64) NOT NULL COMMENT '公告标题',
  `type` bigint(20) NOT NULL COMMENT '公告类型',
  `tag` int(11) DEFAULT NULL COMMENT '标签',
  `content` longtext NOT NULL COMMENT '公告内容',
  `receiver` json DEFAULT NULL COMMENT '接收者',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '公告状态',
  `created_by` bigint(20) DEFAULT NULL COMMENT '发送人',
  `updated_by` bigint(20) DEFAULT '0' COMMENT '修改人',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间'
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_通知公告';

--
-- 转存表中的数据 `hg_admin_notice`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_notice_read`
--

CREATE TABLE IF NOT EXISTS `hg_admin_notice_read` (
  `id` bigint(20) NOT NULL COMMENT '记录ID',
  `notice_id` bigint(20) NOT NULL COMMENT '公告ID',
  `member_id` bigint(20) NOT NULL COMMENT '会员ID',
  `clicks` int(11) DEFAULT '1' COMMENT '已读次数',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `created_at` datetime DEFAULT NULL COMMENT '阅读时间'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_公告已读记录';

--
-- 转存表中的数据 `hg_admin_notice_read`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_oauth`
--

CREATE TABLE IF NOT EXISTS `hg_admin_oauth` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `member_id` bigint(20) DEFAULT '0' COMMENT '用户ID',
  `unionid` varchar(64) DEFAULT '' COMMENT '唯一ID',
  `oauth_client` varchar(32) DEFAULT NULL COMMENT '授权组别',
  `oauth_openid` varchar(128) DEFAULT NULL COMMENT '授权开放ID',
  `sex` tinyint(1) DEFAULT '1' COMMENT '性别',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '昵称',
  `head_portrait` varchar(512) DEFAULT NULL COMMENT '头像',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `country` varchar(100) DEFAULT '' COMMENT '国家',
  `province` varchar(100) DEFAULT '' COMMENT '省',
  `city` varchar(100) DEFAULT '' COMMENT '市',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(1) DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员_第三方登录';

-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_order`
--

CREATE TABLE IF NOT EXISTS `hg_admin_order` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `member_id` bigint(20) DEFAULT '0' COMMENT '管理员id',
  `order_type` varchar(32) NOT NULL COMMENT '订单类型',
  `product_id` bigint(20) DEFAULT NULL COMMENT '产品id',
  `order_sn` varchar(64) DEFAULT '' COMMENT '关联订单号',
  `money` decimal(10,2) NOT NULL COMMENT '充值金额',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `refund_reason` varchar(255) DEFAULT NULL COMMENT '退款原因',
  `reject_refund_reason` varchar(255) DEFAULT NULL COMMENT '拒绝退款原因',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_充值订单';

-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_post`
--

CREATE TABLE IF NOT EXISTS `hg_admin_post` (
  `id` bigint(20) NOT NULL COMMENT '岗位ID',
  `code` varchar(64) NOT NULL COMMENT '岗位编码',
  `name` varchar(50) NOT NULL COMMENT '岗位名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `sort` int(11) NOT NULL COMMENT '排序',
  `status` tinyint(1) NOT NULL COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_岗位';

--
-- 转存表中的数据 `hg_admin_post`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_role`
--

CREATE TABLE IF NOT EXISTS `hg_admin_role` (
  `id` bigint(20) NOT NULL COMMENT '角色ID',
  `name` varchar(32) NOT NULL COMMENT '角色名称',
  `key` varchar(128) NOT NULL COMMENT '角色权限字符串',
  `data_scope` tinyint(1) DEFAULT '1' COMMENT '数据范围',
  `custom_dept` json DEFAULT NULL COMMENT '自定义部门权限',
  `pid` bigint(20) DEFAULT '0' COMMENT '上级角色ID',
  `level` int(11) NOT NULL DEFAULT '1' COMMENT '关系树等级',
  `tree` varchar(512) DEFAULT NULL COMMENT '关系树',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '角色状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COMMENT='管理员_角色信息';

--
-- 转存表中的数据 `hg_admin_role`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_role_casbin`
--

CREATE TABLE IF NOT EXISTS `hg_admin_role_casbin` (
  `id` bigint(20) NOT NULL,
  `p_type` varchar(64) DEFAULT NULL,
  `v0` varchar(256) DEFAULT NULL,
  `v1` varchar(256) DEFAULT NULL,
  `v2` varchar(256) DEFAULT NULL,
  `v3` varchar(256) DEFAULT NULL,
  `v4` varchar(256) DEFAULT NULL,
  `v5` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='管理员_casbin权限表';

-- --------------------------------------------------------

--
-- 表的结构 `hg_admin_role_menu`
--

CREATE TABLE IF NOT EXISTS `hg_admin_role_menu` (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员_角色菜单关联';

--
-- 转存表中的数据 `hg_admin_role_menu`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_pay_log`
--

CREATE TABLE IF NOT EXISTS `hg_pay_log` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `member_id` bigint(20) DEFAULT '0' COMMENT '会员ID',
  `app_id` varchar(50) DEFAULT NULL COMMENT '应用ID',
  `addons_name` varchar(100) DEFAULT '' COMMENT '插件名称',
  `order_sn` varchar(64) DEFAULT '' COMMENT '关联订单号',
  `order_group` varchar(32) DEFAULT '' COMMENT '组别[默认统一支付类型]',
  `openid` varchar(50) DEFAULT '' COMMENT 'openid',
  `mch_id` varchar(20) DEFAULT '' COMMENT '商户支付账户',
  `subject` varchar(255) DEFAULT NULL COMMENT '订单标题',
  `detail` json DEFAULT NULL COMMENT '支付商品详情',
  `auth_code` varchar(50) DEFAULT '' COMMENT '刷卡码',
  `out_trade_no` varchar(128) DEFAULT '' COMMENT '商户订单号',
  `transaction_id` varchar(128) DEFAULT NULL COMMENT '交易号',
  `pay_type` varchar(32) NOT NULL COMMENT '支付类型',
  `pay_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `actual_amount` decimal(10,2) DEFAULT NULL COMMENT '实付金额',
  `pay_status` tinyint(4) DEFAULT '0' COMMENT '支付状态',
  `pay_at` datetime DEFAULT NULL COMMENT '支付时间',
  `trade_type` varchar(16) DEFAULT '' COMMENT '交易类型',
  `refund_sn` varchar(128) DEFAULT NULL COMMENT '退款单号',
  `is_refund` tinyint(4) DEFAULT '0' COMMENT '是否退款 ',
  `custom` text COMMENT '自定义参数',
  `create_ip` varchar(128) DEFAULT NULL COMMENT '创建者IP',
  `pay_ip` varchar(128) DEFAULT NULL COMMENT '支付者IP',
  `notify_url` varchar(255) DEFAULT NULL COMMENT '支付通知回调地址',
  `return_url` varchar(255) DEFAULT NULL COMMENT '买家付款成功跳转地址',
  `trace_ids` json DEFAULT NULL COMMENT '链路ID集合',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='支付_支付日志';

-- --------------------------------------------------------

--
-- 表的结构 `hg_pay_refund`
--

CREATE TABLE IF NOT EXISTS `hg_pay_refund` (
  `id` bigint(20) unsigned NOT NULL COMMENT '主键ID',
  `member_id` bigint(20) DEFAULT '0' COMMENT '会员ID',
  `app_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '应用ID',
  `order_sn` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '业务订单号',
  `refund_trade_no` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '退款交易号',
  `refund_money` decimal(10,2) DEFAULT NULL COMMENT '退款金额',
  `refund_way` tinyint(4) DEFAULT '1' COMMENT '退款方式',
  `ip` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '申请者IP',
  `reason` varchar(255) DEFAULT NULL COMMENT '申请退款原因',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '退款备注',
  `status` tinyint(4) DEFAULT '1' COMMENT '退款状态',
  `created_at` datetime DEFAULT NULL COMMENT '申请时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付_退款记录';

-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_addons_config`
--

CREATE TABLE IF NOT EXISTS `hg_sys_addons_config` (
  `id` bigint(20) NOT NULL COMMENT '配置ID',
  `addon_name` varchar(128) NOT NULL COMMENT '插件名称',
  `group` varchar(128) NOT NULL COMMENT '分组',
  `name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `type` varchar(32) NOT NULL COMMENT '键值类型:string,int,uint,bool,datetime,date',
  `key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `default_value` varchar(500) NOT NULL COMMENT '默认值',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `tip` varchar(500) DEFAULT NULL COMMENT '变量描述',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否为系统默认',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='系统_插件配置';

--
-- 转存表中的数据 `hg_sys_addons_config`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_addons_install`
--

CREATE TABLE IF NOT EXISTS `hg_sys_addons_install` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `name` varchar(255) NOT NULL COMMENT '插件名称',
  `version` varchar(128) NOT NULL DEFAULT '' COMMENT '版本号',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='系统_插件安装记录';

--
-- 转存表中的数据 `hg_sys_addons_install`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_attachment`
--

CREATE TABLE IF NOT EXISTS `hg_sys_attachment` (
  `id` bigint(20) NOT NULL COMMENT '文件ID',
  `app_id` varchar(64) NOT NULL COMMENT '应用ID',
  `member_id` bigint(20) DEFAULT '0' COMMENT '管理员ID',
  `cate_id` bigint(20) unsigned DEFAULT '0' COMMENT '上传分类',
  `drive` varchar(64) DEFAULT NULL COMMENT '上传驱动',
  `name` varchar(1000) DEFAULT NULL COMMENT '文件原始名',
  `kind` varchar(16) DEFAULT NULL COMMENT '上传类型',
  `mime_type` varchar(128) NOT NULL DEFAULT '' COMMENT '扩展类型',
  `naive_type` varchar(32) DEFAULT NULL COMMENT 'NaiveUI类型',
  `path` varchar(1000) DEFAULT NULL COMMENT '本地路径',
  `file_url` varchar(1000) DEFAULT NULL COMMENT 'url',
  `size` bigint(20) DEFAULT '0' COMMENT '文件大小',
  `ext` varchar(50) DEFAULT NULL COMMENT '扩展名',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5校验码',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COMMENT='系统_附件管理';

-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_blacklist`
--

CREATE TABLE IF NOT EXISTS `hg_sys_blacklist` (
  `id` bigint(20) NOT NULL COMMENT '黑名单ID',
  `ip` varchar(100) DEFAULT '' COMMENT 'IP地址',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COMMENT='系统_访问黑名单';

--
-- 转存表中的数据 `hg_sys_blacklist`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_config`
--

CREATE TABLE IF NOT EXISTS `hg_sys_config` (
  `id` bigint(20) NOT NULL COMMENT '配置ID',
  `group` varchar(128) NOT NULL COMMENT '配置分组',
  `name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `type` varchar(32) NOT NULL COMMENT '键值类型:string,int,uint,bool,datetime,date',
  `key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `value` longtext COMMENT '参数键值',
  `default_value` varchar(500) NOT NULL COMMENT '默认值',
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `tip` varchar(500) DEFAULT NULL COMMENT '变量描述',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否为系统默认',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COMMENT='系统_配置';

--
-- 转存表中的数据 `hg_sys_config`
--

(29, 'upload', '上传图片大小限制', 'int', 'uploadImageSize', '1', '2', 310, '单位：MB', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(30, 'upload', '上传图片类型限制', 'string', 'uploadImageType', 'jpg,jpeg,gif,npm,png,svg', 'jpg,jpeg,gif,npm,png,svg', 320, '图片上传后缀类型限制', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(31, 'upload', '上传文件大小限制', 'int', 'uploadFileSize', '1000', '10', 330, '单位：MB', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(32, 'upload', '上传文件类型限制', 'string', 'uploadFileType', 'doc,docx,pdf,zip,tar,xls,xlsx,rar,jpg,jpeg,gif,npm,png,svg', 'doc,docx,zip,xls,xlsx,rar,jpg,jpeg,gif,npm,png,svg', 340, '文件上传后缀类型限制', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(33, 'upload', '本地存储路径', 'string', 'uploadLocalPath', 'attachment/', 'attachment/', 350, '对外访问的相对路径', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(34, 'upload', 'UCloud存储路径', 'string', 'uploadUCloudPath', 'hotgo/attachment/', 'hotgo/attachment/', 360, 'UC对象存储中的相对路径', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(35, 'upload', 'UCloud公钥', 'string', 'uploadUCloudPublicKey', '', '', 370, '获取地址：https://console.ucloud.cn/ufile/token', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(36, 'upload', 'UCloud私钥', 'string', 'uploadUCloudPrivateKey', '', '', 380, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(37, 'upload', 'UCloud地域API', 'string', 'uploadUCloudBucketHost', 'api.ucloud.cn', 'api.ucloud.cn', 390, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(38, 'upload', 'UCloud存储桶名称', 'string', 'uploadUCloudBucketName', 'bufanyun', '', 400, '存储空间名称', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(39, 'upload', 'UCloud存储桶地域host', 'string', 'uploadUCloudFileHost', 'cn-bj.ufileos.com', 'cn-bj.ufileos.com', 410, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(40, 'upload', 'UCloud访问域名', 'string', 'uploadUCloudEndpoint', 'https://gmycos.facms.cn', '', 420, '格式，http://abc.com 或  https://abc.com，不可为空', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(41, 'geo', '高德Web服务key', 'string', 'geoAmapWebKey', '', '', 500, '申请地址：https://console.amap.com/dev/key/app', 1, 1, '2021-01-30 13:27:43', '2022-12-07 15:48:43'),
(42, 'sms', '短信驱动,aliyun：阿里云;tencent：腾讯云', 'string', 'smsDrive', 'tencent', '', 600, '', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(43, 'sms', '阿里云AccessKeyID', 'string', 'smsAliYunAccessKeyID', '', '', 610, '应用key和密钥你可以通过 https://ram.console.aliyun.com/manage/ak 获取', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(44, 'sms', '阿里云AccessKeySecret', 'string', 'smsAliYunAccessKeySecret', '', '', 620, '', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(45, 'sms', '阿里云短信签名', 'string', 'smsAliYunSign', '', '', 630, '申请地址：https://dysms.console.aliyun.com/domestic/text/sign', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(46, 'sms', '阿里云短信模板', 'string', 'smsAliYunTemplate', '[{"key":"login","value":"SMS_198921686"},{"key":"register","value":"SMS_198921686"},{"key":"code","value":"SMS_198921686"},{"key":"resetPwd","value":"SMS_198921686"},{"key":"bind","value":"SMS_198921686"},{"key":"cash","value":"SMS_198921686"}]', '', 640, '', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(47, 'sms', '最小发送间隔', 'int', 'smsMinInterval', '60', '', 600, '同号码', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(48, 'sms', 'IP最大发送次数', 'int', 'smsMaxIpLimit', '10', '', 610, '同IP每天最大允许发送次数', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(49, 'sms', '验证码有效期', 'int', 'smsCodeExpire', '600', '', 610, '单位：秒', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(50, 'smtp', '邮件模板', 'string', 'smtpTemplate', '[{"key":"text","value":"./resource/template/email/text.html"},{"key":"login","value":"./resource/template/email/code.html"},{"key":"register","value":"./resource/template/email/code.html"},{"key":"code","value":"./resource/template/email/code.html"},{"key":"resetPwd","value":"./resource/template/email/resetPwd.html"},{"key":"bind","value":"./resource/template/email/code.html"},{"key":"cash","value":"./resource/template/email/code.html"}]', '', 190, '', 1, 1, '2021-01-30 13:27:43', '2023-02-04 16:59:13'),
(51, 'smtp', '最小发送间隔', 'int', 'smtpMinInterval', '60', '', 150, '同地址', 1, 1, '2021-01-30 13:27:43', '2023-02-04 16:59:13'),
(52, 'smtp', 'IP最大发送次数', 'int', 'smtpMaxIpLimit', '10', '', 160, '同IP每天最大允许发送次数', 1, 1, '2021-01-30 13:27:43', '2023-02-04 16:59:13'),
(53, 'smtp', '验证码有效期', 'int', 'smtpCodeExpire', '600', '', 170, '单位：秒', 1, 1, '2021-01-30 13:27:43', '2023-02-04 16:59:13'),
(54, 'basic', '网站域名', 'string', 'basicDomain', 'http://127.0.0.1:8000', 'http://127.0.0.1:8000', 45, '', 1, 1, '2021-01-30 13:27:43', '2024-04-21 22:58:30'),
(55, 'basic', 'websocket地址', 'string', 'basicWsAddr', 'ws://127.0.0.1:8000/socket', 'ws://127.0.0.1:8000/socket', 48, '', 1, 1, '2021-01-30 13:27:43', '2024-04-21 22:58:30'),
(56, 'upload', 'COS存储路径', 'string', 'uploadCosPath', 'hotgo/attachment/', 'hotgo/attachment/', 450, 'COS对象存储中的相对路径', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(57, 'upload', 'COS秘钥ID', 'string', 'uploadCosSecretId', '', '', 460, '子账号密钥获取可参考 https://cloud.tencent.com/document/product/598/37140', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(58, 'upload', 'COS秘钥', 'string', 'uploadCosSecretKey', '', '', 470, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(59, 'upload', 'COS访问域名', 'string', 'uploadCosBucketURL', '', 'https://xxx-1253625515.cos.ap-beijing.myqcloud.com', 480, '控制台查看地址：https://console.cloud.tencent.com/cos/bucket', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(60, 'upload', 'OSS存储路径', 'string', 'uploadOssPath', 'hotgo/attachment/', 'hotgo/attachment/', 500, 'OSS对象存储中的相对路径', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(61, 'upload', 'OSS秘钥ID', 'string', 'uploadOssSecretId', '', '', 510, '阿里云账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM用户进行API访问或日常运维，请登录RAM控制台创建RAM用户。', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(62, 'upload', 'OSS秘钥', 'string', 'uploadOssSecretKey', '', '', 520, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(63, 'upload', 'Bucket 域名', 'string', 'uploadOssBucketURL', 'http://bufanyunoss.oss-cn-qingdao.aliyuncs.com', 'https://xxx.oss-cn-qingdao.aliyuncs.com', 530, 'Bucket 域名', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(64, 'upload', 'OSSEndpoint', 'string', 'uploadOssEndpoint', 'http://oss-cn-qingdao.aliyuncs.com', 'https://oss-cn-qingdao.aliyuncs.com', 540, 'Endpoint（地域节点）', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(65, 'upload', 'OSS存储空间名称', 'string', 'uploadOssBucket', '', '', 550, '存储空间名称，例如examplebucket', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(66, 'upload', '七牛云AccessKey', 'string', 'uploadQiNiuAccessKey', '', '', 600, '创建地址：https://portal.qiniu.com/user/key', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(67, 'upload', '七牛云SecretKey', 'string', 'uploadQiNiuSecretKey', '', '', 610, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(68, 'upload', '七牛云储存路径', 'string', 'uploadQiNiuPath', 'hotgo/attachment/', 'hotgo/attachment/', 620, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(69, 'upload', '七牛云存储空间名称', 'string', 'uploadQiNiuBucket', '', 'bufanyun', 630, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(70, 'upload', '七牛云访问域名', 'string', 'uploadQiNiuDomain', '', '', 640, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(78, 'sms', '腾讯云SecretId', 'string', 'smsTencentSecretId', '', '', 650, '获取地址：https://console.cloud.tencent.com/cam/capi', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(79, 'sms', '腾讯云SecretKey', 'string', 'smsTencentSecretKey', '', '', 660, '', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(80, 'sms', '腾讯云短信应用ID', 'string', 'smsTencentAppId', '', '', 670, '查看地址：https://console.cloud.tencent.com/smsv2/app-manage', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(81, 'sms', '腾讯云短信签名', 'string', 'smsTencentSign', '', '', 680, '查看地址：https://console.cloud.tencent.com/smsv2/csms-sign', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(82, 'sms', '腾讯云接入地域域名', 'string', 'smsTencentEndpoint', 'sms.tencentcloudapi.com', 'sms.tencentcloudapi.com', 690, '默认就近地域接入域名为 sms.tencentcloudapi.com ，也支持指定地域域名访问，例如广州地域的域名为 sms.ap-guangzhou.tencentcloudapi.com', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(83, 'sms', '腾讯云地域信息', 'string', 'smsTencentRegion', 'ap-guangzhou', 'ap-guangzhou', 695, '支持的地域列表参考 https://cloud.tencent.com/document/api/382/52071#.E5.9C.B0.E5.9F.9F.E5.88.97.E8.A1.A8', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(84, 'sms', '腾讯云短信模板', 'string', 'smsTencentTemplate', '[{"key":"login","value":"1758990"},{"key":"register","value":"1758990"},{"key":"code","value":"1758990"},{"key":"resetPwd","value":"1758990"},{"key":"bind","value":"1758990"},{"key":"cash","value":"1758990"}]', '', 698, '', 1, 1, '2021-01-30 13:27:43', '2023-04-10 13:55:32'),
(85, 'pay', 'Debug开关', 'bool', 'payDebug', '1', 'true', 800, '输出请求日志', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(86, 'pay', '支付宝应用ID', 'string', 'payAliPayAppId', '', '', 810, '', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(87, 'pay', '支付宝PrivateKey', 'string', 'payAliPayPrivateKey', 'storage/cert/pay/alipay/alipayPrivateKey', '', 820, '应用私钥，支持PKCS1和PKCS8', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(88, 'pay', '支付宝AppCertPublicKey', 'string', 'payAliPayAppCertPublicKey', 'storage/cert/pay/alipay/appCertPublicKey.crt', '', 830, 'appCertPublicKey.crt证书内容', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(89, 'pay', '支付宝RootCert', 'string', 'payAliPayRootCert', 'storage/cert/pay/alipay/alipayRootCert.crt', '', 840, 'alipayRootCert.crt证书内容', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(90, 'pay', '支付宝PublicKeyRSA2', 'string', 'payAliPayCertPublicKeyRSA2', 'storage/cert/pay/alipay/alipayCertPublicKey_RSA2.crt', '', 850, 'alipayCertPublicKey_RSA2.crt证书内容', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(91, 'pay', '微信支付应用ID', 'string', 'payWxPayAppId', '', '', 860, '', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(92, 'pay', '微信支付商户ID', 'string', 'payWxPayMchId', '', '', 870, '商户ID 或者服务商模式的 sp_mchid', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(93, 'pay', '微信支付证书序列号', 'string', 'payWxPaySerialNo', '', '', 880, '商户证书的证书序列号', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(94, 'pay', '微信支付APIv3Key', 'string', 'payWxPayAPIv3Key', '', '', 890, '商户平台获取', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(95, 'pay', '微信支付私钥', 'string', 'payWxPayPrivateKey', '', '', 900, 'apiclient_key.pem 读取后的内容', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(96, 'pay', 'QQ支付应用ID', 'string', 'payQQPayAppId', '', '', 910, '', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(97, 'pay', 'QQ支付商户ID', 'string', 'payQQPayMchId', '', '', 920, '', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(98, 'pay', 'QQ支付ApiKey', 'string', 'payQQPayApiKey', '', '', 930, 'API秘钥值', 1, 1, '2021-01-30 13:27:43', '2023-08-05 14:00:56'),
(99, 'cash', '提现开关', 'int', 'cashSwitch', '1', '1', 200, '', 1, 1, '2021-09-29 23:51:21', '2022-12-21 21:58:52'),
(100, 'cash', '提现最低手续费（元）', 'int', 'cashMinFee', '3', '3', 210, '', 1, 1, '2021-09-29 23:51:21', '2022-12-21 21:58:52'),
(101, 'cash', '提现最低手续费比率', 'string', 'cashMinFeeRatio', '0.03', '0.03', 220, '', 1, 1, '2021-01-30 13:27:43', '2022-12-21 21:58:52'),
(102, 'cash', '提现最低金额', 'int', 'cashMinMoney', '100', '', 230, '', 1, 1, '2021-01-30 13:27:43', '2022-12-21 21:58:52'),
(103, 'cash', '提现提示信息', 'string', 'cashTips', '<p>温馨提示：请保证支付宝信息姓名、账号、收款码信息一致且无误，否则导致不到账后果自负。</p>\n\n <p>提现条件：满100元后可申请提现。</p>\n <p>提现手续费：固定3元/次，提现金额超过100元按3%收取，封顶135元/次。</p>', '', 240, '', 1, 1, '2021-01-30 13:27:43', '2022-12-21 21:58:52'),
(104, 'wechat', '公众号AppId', 'string', 'officialAccountAppId', '', '', 1000, '请填写微信公众平台后台的AppId', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(105, 'wechat', '公众号AppSecret', 'string', 'officialAccountAppSecret', '', '', 1010, '请填写微信公众平台后台的AppSecret', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(106, 'wechat', '公众号token', 'string', 'officialAccountToken', '', '', 1020, '', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(107, 'wechat', '公众号EncodingAESKey', 'string', 'officialAccountEncodingAESKey', '', '', 1030, '与公众平台接入设置值一致，必须为英文或者数字，长度为43个字符. 请妥善保管,EncodingAESKey 泄露将可能被窃取或篡改平台的操作数据', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(108, 'wechat', '开放平台AppId', 'string', 'openPlatformAppId', '', '', 1040, '请填写微信开放平台平台后台的AppId', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(109, 'wechat', '开放平台AppSecret', 'string', 'openPlatformAppSecret', '', '', 1050, '请填写微信开放平台平台后台的AppSecret', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(110, 'wechat', '开放平台EncodingAESKey', 'string', 'openPlatformEncodingAESKey', '', '', 1060, '与开放平台接入设置值一致，必须为英文或者数字，长度为43个字符. 请妥善保管,EncodingAESKey 泄露将可能被窃取或篡改平台的操作数据', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(111, 'wechat', '开放平台token', 'string', 'openPlatformToken', '', '', 1070, '', 1, 1, '2021-01-30 13:27:43', '2023-07-26 16:06:53'),
(112, 'login', '注册开关', 'int', 'loginRegisterSwitch', '1', '1', 1100, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(113, 'login', '验证码开关', 'int', 'loginCaptchaSwitch', '1', '1', 1110, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(114, 'login', '用户协议', 'string', 'loginProtocol', '<p><span style="color: rgb(31, 34, 37);">用户协议..</span></p>', '', 1120, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(115, 'login', '隐私权政策', 'string', 'loginPolicy', '<p><span style="color: rgb(31, 34, 37);">隐私权政策..</span></p>', '', 1130, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(116, 'login', '默认注册角色', 'int64', 'loginRoleId', '210', '', 1140, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:49'),
(117, 'login', '默认注册部门', 'int64', 'loginDeptId', '110', '', 1150, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(118, 'login', '默认注册岗位', '[]int64', 'loginPostIds', '[4]', '', 1160, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(119, 'login', '默认注册头像', 'string', 'loginAvatar', 'https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8er9nfkchdopav.png', '', 1170, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(120, 'login', '强制邀请', 'int', 'loginForceInvite', '2', '1', 1190, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:49'),
(121, 'login', '自动获取openId', 'int', 'loginAutoOpenId', '2', '1', 1195, '', 1, 1, '2021-09-29 23:51:21', '2024-08-27 19:02:48'),
(122, 'upload', 'minio AccessKey', 'string', 'uploadMinioAccessKey', '', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(123, 'upload', 'minio SecretKey', 'string', 'uploadMinioSecretKey', '', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(124, 'upload', 'minio地域节点', 'string', 'uploadMinioEndpoint', '', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(125, 'upload', 'minio是否启用SSL', 'int', 'uploadMinioUseSSL', '1', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(126, 'upload', 'minio存储路径', 'string', 'uploadMinioPath', 'hotgo/attachment/', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(127, 'upload', 'minio桶名称', 'string', 'uploadMinioBucket', '', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(128, 'upload', 'minio对外访问域名', 'string', 'uploadMinioDomain', '', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35'),
(129, 'login', '验证码方式', 'int', 'loginCaptchaType', '1', '2', 1200, '', 1, 1, '2025-06-25 17:04:39', '2025-06-25 17:23:15');
-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_cron`
--

CREATE TABLE IF NOT EXISTS `hg_sys_cron` (
  `id` bigint(20) NOT NULL COMMENT '任务ID',
  `group_id` bigint(20) NOT NULL COMMENT '分组ID',
  `title` varchar(128) NOT NULL COMMENT '任务标题',
  `name` varchar(100) DEFAULT NULL COMMENT '任务方法',
  `params` varchar(255) DEFAULT NULL COMMENT '函数参数',
  `pattern` varchar(64) NOT NULL COMMENT '表达式',
  `policy` bigint(20) NOT NULL DEFAULT '1' COMMENT '策略',
  `count` bigint(20) NOT NULL DEFAULT '0' COMMENT '执行次数',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '任务状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COMMENT='系统_定时任务';

--
-- 转存表中的数据 `hg_sys_cron`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_cron_group`
--

CREATE TABLE IF NOT EXISTS `hg_sys_cron_group` (
  `id` bigint(20) NOT NULL COMMENT '任务分组ID',
  `pid` bigint(20) NOT NULL COMMENT '父类任务分组ID',
  `name` varchar(100) DEFAULT '' COMMENT '分组名称',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '分组状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='系统_定时任务分组';

--
-- 转存表中的数据 `hg_sys_cron_group`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_dict_data`
--

CREATE TABLE IF NOT EXISTS `hg_sys_dict_data` (
  `id` bigint(20) NOT NULL COMMENT '字典数据ID',
  `label` varchar(100) DEFAULT NULL COMMENT '字典标签',
  `value` varchar(100) DEFAULT NULL COMMENT '字典键值',
  `value_type` varchar(255) NOT NULL DEFAULT 'string' COMMENT '键值数据类型：string,int,uint,bool,datetime,date',
  `type` varchar(100) DEFAULT NULL COMMENT '字典类型',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` tinyint(1) DEFAULT '2' COMMENT '是否为系统默认',
  `sort` int(11) DEFAULT '0' COMMENT '字典排序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=171 DEFAULT CHARSET=utf8mb4 COMMENT='系统_字典数据';

--
-- 转存表中的数据 `hg_sys_dict_data`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_dict_type`
--

CREATE TABLE IF NOT EXISTS `hg_sys_dict_type` (
  `id` bigint(20) NOT NULL COMMENT '字典类型ID',
  `pid` bigint(20) NOT NULL DEFAULT '0' COMMENT '父类字典类型ID',
  `name` varchar(100) DEFAULT '' COMMENT '字典类型名称',
  `type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '字典类型状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COMMENT='系统_字典类型';

--
-- 转存表中的数据 `hg_sys_dict_type`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_ems_log`
--

CREATE TABLE IF NOT EXISTS `hg_sys_ems_log` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `event` varchar(64) NOT NULL COMMENT '事件',
  `email` varchar(512) NOT NULL COMMENT '邮箱地址，多个用;隔开',
  `code` varchar(256) DEFAULT '' COMMENT '验证码',
  `times` bigint(20) NOT NULL COMMENT '验证次数',
  `content` longtext COMMENT '邮件内容',
  `ip` varchar(128) DEFAULT NULL COMMENT 'ip地址',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(1未验证,2已验证)',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='系统_邮件发送记录';

--
-- 转存表中的数据 `hg_sys_ems_log`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_gen_codes`
--

CREATE TABLE IF NOT EXISTS `hg_sys_gen_codes` (
  `id` bigint(20) NOT NULL COMMENT '生成ID',
  `gen_type` int(10) unsigned NOT NULL COMMENT '生成类型',
  `gen_template` int(11) DEFAULT '0' COMMENT '生成模板',
  `var_name` varchar(255) NOT NULL COMMENT '实体命名',
  `options` json DEFAULT NULL COMMENT '配置选项',
  `db_name` varchar(128) DEFAULT NULL COMMENT '数据库名称',
  `table_name` varchar(255) NOT NULL COMMENT '主表名称',
  `table_comment` varchar(255) DEFAULT NULL COMMENT '主表注释',
  `dao_name` varchar(255) DEFAULT NULL COMMENT '主表dao模型',
  `master_columns` json DEFAULT NULL COMMENT '主表字段',
  `addon_name` varchar(128) DEFAULT NULL COMMENT '插件名称',
  `status` tinyint(1) DEFAULT '1' COMMENT '生成状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COMMENT='系统_代码生成记录';

--
-- 转存表中的数据 `hg_sys_gen_codes`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_gen_curd_demo`
--

CREATE TABLE IF NOT EXISTS `hg_sys_gen_curd_demo` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `category_id` bigint(20) DEFAULT '0' COMMENT '分类ID',
  `title` varchar(64) NOT NULL COMMENT '标题',
  `description` varchar(255) DEFAULT '' COMMENT '描述',
  `content` text COMMENT '内容',
  `image` varchar(255) DEFAULT NULL COMMENT '单图',
  `attachfile` varchar(255) DEFAULT NULL COMMENT '附件',
  `city_id` bigint(20) DEFAULT '0' COMMENT '所在城市',
  `switch` int(11) DEFAULT '1' COMMENT '显示开关',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_by` bigint(20) DEFAULT '0' COMMENT '创建者',
  `updated_by` bigint(20) DEFAULT '0' COMMENT '更新者',
  `deleted_by` bigint(20) DEFAULT '0' COMMENT '删除者',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间'
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COMMENT='系统_生成curd演示';

--
-- 转存表中的数据 `hg_sys_gen_curd_demo`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_gen_tree_demo`
--

CREATE TABLE IF NOT EXISTS `hg_sys_gen_tree_demo` (
  `id` bigint(20) NOT NULL COMMENT 'ID',
  `pid` bigint(20) DEFAULT NULL COMMENT '上级ID',
  `level` int(11) DEFAULT '1' COMMENT '关系树级别',
  `tree` varchar(512) DEFAULT NULL COMMENT '关系树',
  `category_id` bigint(20) DEFAULT '0' COMMENT '分类ID',
  `title` varchar(64) NOT NULL COMMENT '标题',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_by` bigint(20) DEFAULT '0' COMMENT '创建者',
  `updated_by` bigint(20) DEFAULT '0' COMMENT '更新者',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间'
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COMMENT='系统_生成树表演示';

--
-- 转存表中的数据 `hg_sys_gen_tree_demo`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_log`
--

CREATE TABLE IF NOT EXISTS `hg_sys_log` (
  `id` bigint(20) NOT NULL COMMENT '日志ID',
  `req_id` varchar(50) DEFAULT NULL COMMENT '对外ID',
  `app_id` varchar(50) DEFAULT '' COMMENT '应用ID',
  `merchant_id` bigint(20) unsigned DEFAULT '0' COMMENT '商户ID',
  `member_id` bigint(20) DEFAULT '0' COMMENT '用户ID',
  `method` varchar(20) DEFAULT NULL COMMENT '提交类型',
  `module` varchar(50) DEFAULT NULL COMMENT '访问模块',
  `url` varchar(1000) DEFAULT NULL COMMENT '提交url',
  `get_data` json DEFAULT NULL COMMENT 'get数据',
  `post_data` json DEFAULT NULL COMMENT 'post数据',
  `header_data` json DEFAULT NULL COMMENT 'header数据',
  `ip` varchar(128) DEFAULT NULL COMMENT 'IP地址',
  `province_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '省编码',
  `city_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '市编码',
  `error_code` int(11) DEFAULT '0' COMMENT '报错code',
  `error_msg` longtext COMMENT '对外错误提示',
  `error_data` json DEFAULT NULL COMMENT '报错日志',
  `user_agent` varchar(512) DEFAULT NULL COMMENT 'UA信息',
  `take_up_time` bigint(20) DEFAULT '0' COMMENT '请求耗时',
  `timestamp` bigint(20) DEFAULT '0' COMMENT '响应时间',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统_全局日志';

-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_login_log`
--

CREATE TABLE IF NOT EXISTS `hg_sys_login_log` (
  `id` bigint(20) NOT NULL COMMENT '日志ID',
  `req_id` varchar(50) DEFAULT NULL COMMENT '请求ID',
  `member_id` bigint(20) DEFAULT '0' COMMENT '用户ID',
  `username` varchar(64) DEFAULT NULL COMMENT '用户名',
  `response` json DEFAULT NULL COMMENT '响应数据',
  `login_at` datetime DEFAULT NULL COMMENT '登录时间',
  `login_ip` varchar(128) DEFAULT NULL COMMENT '登录IP',
  `province_id` bigint(20) DEFAULT NULL COMMENT '省编码',
  `city_id` bigint(20) DEFAULT NULL COMMENT '市编码',
  `user_agent` varchar(512) DEFAULT NULL COMMENT 'UA信息',
  `err_msg` varchar(1000) DEFAULT NULL COMMENT '错误提示',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统_登录日志';

-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_provinces`
--

CREATE TABLE IF NOT EXISTS `hg_sys_provinces` (
  `id` bigint(20) NOT NULL COMMENT '省市区ID',
  `title` varchar(50) NOT NULL DEFAULT '' COMMENT '栏目名称',
  `pinyin` varchar(100) DEFAULT '' COMMENT '拼音',
  `lng` varchar(20) DEFAULT '' COMMENT '经度',
  `lat` varchar(20) DEFAULT '' COMMENT '纬度',
  `pid` bigint(20) NOT NULL DEFAULT '0' COMMENT '父栏目',
  `level` int(11) NOT NULL DEFAULT '1' COMMENT '关系树等级',
  `tree` varchar(200) DEFAULT NULL COMMENT '关系树',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='系统_省市区编码';

--
-- 转存表中的数据 `hg_sys_provinces`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_serve_license`
--

CREATE TABLE IF NOT EXISTS `hg_sys_serve_license` (
  `id` bigint(20) NOT NULL COMMENT '许可ID',
  `group` varchar(50) NOT NULL COMMENT '分组',
  `name` varchar(128) NOT NULL COMMENT '许可名称',
  `appid` varchar(64) NOT NULL COMMENT '应用ID',
  `secret_key` varchar(255) DEFAULT NULL COMMENT '应用秘钥',
  `remote_addr` varchar(64) DEFAULT NULL COMMENT '最后连接地址',
  `online_limit` int(11) DEFAULT '1' COMMENT '在线限制',
  `login_times` bigint(20) DEFAULT NULL COMMENT '登录次数',
  `last_login_at` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_active_at` datetime DEFAULT NULL COMMENT '最后心跳',
  `routes` json DEFAULT NULL COMMENT '路由表，空使用默认分组路由',
  `allowed_ips` varchar(512) DEFAULT NULL COMMENT 'IP白名单',
  `end_at` datetime NOT NULL COMMENT '授权有效期',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COMMENT='系统_服务许可证';

--
-- 转存表中的数据 `hg_sys_serve_license`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_serve_log`
--

CREATE TABLE IF NOT EXISTS `hg_sys_serve_log` (
  `id` bigint(20) NOT NULL COMMENT '日志ID',
  `trace_id` varchar(50) DEFAULT NULL COMMENT '链路ID',
  `level_format` varchar(32) DEFAULT NULL COMMENT '日志级别',
  `content` text COMMENT '日志内容',
  `stack` json DEFAULT NULL COMMENT '打印堆栈',
  `line` varchar(255) NOT NULL COMMENT '调用行',
  `trigger_ns` bigint(20) DEFAULT NULL COMMENT '触发时间(ns)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统_服务日志';

-- --------------------------------------------------------

--
-- 表的结构 `hg_sys_sms_log`
--

CREATE TABLE IF NOT EXISTS `hg_sys_sms_log` (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `event` varchar(64) NOT NULL COMMENT '事件',
  `mobile` varchar(20) NOT NULL DEFAULT '' COMMENT '手机号',
  `code` varchar(256) DEFAULT '' COMMENT '验证码或短信内容',
  `times` bigint(20) NOT NULL COMMENT '验证次数',
  `ip` varchar(128) DEFAULT NULL COMMENT 'ip地址',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态(1未验证,2已验证)',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='系统_短信发送记录';

--
-- 转存表中的数据 `hg_sys_sms_log`
--


-- --------------------------------------------------------

--
-- 表的结构 `hg_test_category`
--

CREATE TABLE IF NOT EXISTS `hg_test_category` (
  `id` bigint(20) NOT NULL COMMENT '分类ID',
  `name` varchar(255) NOT NULL COMMENT '分类名称',
  `short_name` varchar(128) DEFAULT NULL COMMENT '简称',
  `description` varchar(255) DEFAULT NULL COMMENT '描述',
  `sort` int(11) NOT NULL COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间'
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='测试分类';

--
-- 转存表中的数据 `hg_test_category`
--


--
-- Indexes for dumped tables
--

--
-- Indexes for table `hg_addon_hgexample_table`
--
ALTER TABLE `hg_addon_hgexample_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hg_addon_hgexample_tenant_order`
--
ALTER TABLE `hg_addon_hgexample_tenant_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_sn` (`order_sn`),
  ADD KEY `member_id` (`user_id`),
  ADD KEY `merchant_id` (`merchant_id`),
  ADD KEY `agent_id` (`tenant_id`);

--
-- Indexes for table `hg_admin_cash`
--
ALTER TABLE `hg_admin_cash`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`member_id`);

--
-- Indexes for table `hg_admin_credits_log`
--
ALTER TABLE `hg_admin_credits_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `hg_admin_dept`
--
ALTER TABLE `hg_admin_dept`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid` (`pid`);

--
-- Indexes for table `hg_admin_member`
--
ALTER TABLE `hg_admin_member`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invite_code` (`invite_code`),
  ADD KEY `dept_id` (`dept_id`),
  ADD KEY `pid` (`pid`);

--
-- Indexes for table `hg_admin_member_post`
--
ALTER TABLE `hg_admin_member_post`
  ADD PRIMARY KEY (`member_id`,`post_id`);

--
-- Indexes for table `hg_admin_member_role`
--
ALTER TABLE `hg_admin_member_role`
  ADD PRIMARY KEY (`member_id`,`role_id`);

--
-- Indexes for table `hg_admin_menu`
--
ALTER TABLE `hg_admin_menu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `pid` (`pid`),
  ADD KEY `status` (`status`),
  ADD KEY `type` (`type`);

--
-- Indexes for table `hg_admin_notice`
--
ALTER TABLE `hg_admin_notice`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hg_admin_notice_read`
--
ALTER TABLE `hg_admin_notice_read`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `notice_id` (`notice_id`,`member_id`);

--
-- Indexes for table `hg_admin_oauth`
--
ALTER TABLE `hg_admin_oauth`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_client` (`oauth_client`,`oauth_openid`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `hg_admin_order`
--
ALTER TABLE `hg_admin_order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_sn` (`order_sn`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `hg_admin_post`
--
ALTER TABLE `hg_admin_post`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hg_admin_role`
--
ALTER TABLE `hg_admin_role`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hg_admin_role_casbin`
--
ALTER TABLE `hg_admin_role_casbin`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `hg_admin_role_menu`
--
ALTER TABLE `hg_admin_role_menu`
  ADD PRIMARY KEY (`role_id`,`menu_id`);

--
-- Indexes for table `hg_pay_log`
--
ALTER TABLE `hg_pay_log`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_sn` (`order_sn`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `hg_pay_refund`
--
ALTER TABLE `hg_pay_refund`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_sn` (`order_sn`);

--
-- Indexes for table `hg_sys_addons_config`
--
ALTER TABLE `hg_sys_addons_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `addon_name_2` (`addon_name`,`key`),
  ADD KEY `addon_name` (`addon_name`),
  ADD KEY `addon_name_3` (`addon_name`,`group`);

--
-- Indexes for table `hg_sys_addons_install`
--
ALTER TABLE `hg_sys_addons_install`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `hg_sys_attachment`
--
ALTER TABLE `hg_sys_attachment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `md5` (`md5`);

--
-- Indexes for table `hg_sys_blacklist`
--
ALTER TABLE `hg_sys_blacklist`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `name` (`ip`);

--
-- Indexes for table `hg_sys_config`
--
ALTER TABLE `hg_sys_config`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group` (`group`),
  ADD KEY `key` (`key`);

--
-- Indexes for table `hg_sys_cron`
--
ALTER TABLE `hg_sys_cron`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `hg_sys_cron_group`
--
ALTER TABLE `hg_sys_cron_group`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `hg_sys_dict_data`
--
ALTER TABLE `hg_sys_dict_data`
  ADD PRIMARY KEY (`id`),
  ADD KEY `dict_data_idx` (`type`);

--
-- Indexes for table `hg_sys_dict_type`
--
ALTER TABLE `hg_sys_dict_type`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `dict_type` (`type`);

--
-- Indexes for table `hg_sys_ems_log`
--
ALTER TABLE `hg_sys_ems_log`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `email` (`email`);

--
-- Indexes for table `hg_sys_gen_codes`
--
ALTER TABLE `hg_sys_gen_codes`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `hg_sys_gen_curd_demo`
--
ALTER TABLE `hg_sys_gen_curd_demo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hg_sys_gen_tree_demo`
--
ALTER TABLE `hg_sys_gen_tree_demo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hg_sys_log`
--
ALTER TABLE `hg_sys_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `error_code` (`error_code`),
  ADD KEY `req_id` (`req_id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `hg_sys_login_log`
--
ALTER TABLE `hg_sys_login_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`),
  ADD KEY `req_id` (`req_id`);

--
-- Indexes for table `hg_sys_provinces`
--
ALTER TABLE `hg_sys_provinces`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pid` (`pid`);

--
-- Indexes for table `hg_sys_serve_license`
--
ALTER TABLE `hg_sys_serve_license`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `appid` (`appid`);

--
-- Indexes for table `hg_sys_serve_log`
--
ALTER TABLE `hg_sys_serve_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`level_format`),
  ADD KEY `traceid` (`trace_id`);

--
-- Indexes for table `hg_sys_sms_log`
--
ALTER TABLE `hg_sys_sms_log`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `mobile` (`mobile`);

--
-- Indexes for table `hg_test_category`
--
ALTER TABLE `hg_test_category`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hg_addon_hgexample_table`
--
ALTER TABLE `hg_addon_hgexample_table`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `hg_addon_hgexample_tenant_order`
--
ALTER TABLE `hg_addon_hgexample_tenant_order`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_admin_cash`
--
ALTER TABLE `hg_admin_cash`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_admin_credits_log`
--
ALTER TABLE `hg_admin_credits_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '变动ID',AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `hg_admin_dept`
--
ALTER TABLE `hg_admin_dept`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门ID',AUTO_INCREMENT=113;
--
-- AUTO_INCREMENT for table `hg_admin_member`
--
ALTER TABLE `hg_admin_member`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '管理员ID',AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `hg_admin_menu`
--
ALTER TABLE `hg_admin_menu`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',AUTO_INCREMENT=2431;
--
-- AUTO_INCREMENT for table `hg_admin_notice`
--
ALTER TABLE `hg_admin_notice`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '公告ID',AUTO_INCREMENT=33;
--
-- AUTO_INCREMENT for table `hg_admin_notice_read`
--
ALTER TABLE `hg_admin_notice_read`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `hg_admin_oauth`
--
ALTER TABLE `hg_admin_oauth`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键';
--
-- AUTO_INCREMENT for table `hg_admin_order`
--
ALTER TABLE `hg_admin_order`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_admin_post`
--
ALTER TABLE `hg_admin_post`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `hg_admin_role`
--
ALTER TABLE `hg_admin_role`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',AUTO_INCREMENT=211;
--
-- AUTO_INCREMENT for table `hg_admin_role_casbin`
--
ALTER TABLE `hg_admin_role_casbin`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `hg_pay_log`
--
ALTER TABLE `hg_pay_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_pay_refund`
--
ALTER TABLE `hg_pay_refund`
  MODIFY `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID';
--
-- AUTO_INCREMENT for table `hg_sys_addons_config`
--
ALTER TABLE `hg_sys_addons_config`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_sys_addons_install`
--
ALTER TABLE `hg_sys_addons_install`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_sys_attachment`
--
ALTER TABLE `hg_sys_attachment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '文件ID',AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `hg_sys_blacklist`
--
ALTER TABLE `hg_sys_blacklist`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '黑名单ID',AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `hg_sys_config`
--
ALTER TABLE `hg_sys_config`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '配置ID',AUTO_INCREMENT=129;
--
-- AUTO_INCREMENT for table `hg_sys_cron`
--
ALTER TABLE `hg_sys_cron`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `hg_sys_cron_group`
--
ALTER TABLE `hg_sys_cron_group`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务分组ID',AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `hg_sys_dict_data`
--
ALTER TABLE `hg_sys_dict_data`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典数据ID',AUTO_INCREMENT=171;
--
-- AUTO_INCREMENT for table `hg_sys_dict_type`
--
ALTER TABLE `hg_sys_dict_type`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典类型ID',AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT for table `hg_sys_ems_log`
--
ALTER TABLE `hg_sys_ems_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `hg_sys_gen_codes`
--
ALTER TABLE `hg_sys_gen_codes`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '生成ID',AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `hg_sys_gen_curd_demo`
--
ALTER TABLE `hg_sys_gen_curd_demo`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `hg_sys_gen_tree_demo`
--
ALTER TABLE `hg_sys_gen_tree_demo`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',AUTO_INCREMENT=41;
--
-- AUTO_INCREMENT for table `hg_sys_log`
--
ALTER TABLE `hg_sys_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID';
--
-- AUTO_INCREMENT for table `hg_sys_login_log`
--
ALTER TABLE `hg_sys_login_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID';
--
-- AUTO_INCREMENT for table `hg_sys_serve_license`
--
ALTER TABLE `hg_sys_serve_license`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '许可ID',AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `hg_sys_serve_log`
--
ALTER TABLE `hg_sys_serve_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID';
--
-- AUTO_INCREMENT for table `hg_sys_sms_log`
--
ALTER TABLE `hg_sys_sms_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `hg_test_category`
--
ALTER TABLE `hg_test_category`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',AUTO_INCREMENT=5;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

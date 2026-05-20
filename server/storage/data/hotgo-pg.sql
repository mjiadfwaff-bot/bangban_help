-- ==========================================
-- HotGo PostgreSQL 18 Database Schema
-- ==========================================


-- 设置时区
SET TIMEZONE = 'UTC';

-- 创建扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- hg_addon_hgexample_table

CREATE TABLE IF NOT EXISTS hg_addon_hgexample_table (
    id BIGSERIAL PRIMARY KEY,
    pid BIGINT NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    tree TEXT,
    category_id BIGINT,
    flag JSONB,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    content TEXT,
    image VARCHAR(255),
    images JSONB,
    attachfile VARCHAR(255),
    attachfiles JSONB,
    map JSONB,
    star NUMERIC(5,1) DEFAULT 0.0,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    views BIGINT,
    activity_at DATE,
    start_at TIMESTAMP,
    end_at TIMESTAMP,
    switch SMALLINT,
    sort INTEGER,
    avatar VARCHAR(255) DEFAULT '',
    sex SMALLINT,
    qq VARCHAR(20) DEFAULT '',
    email VARCHAR(60) DEFAULT '',
    mobile VARCHAR(20) DEFAULT '',
    hobby JSONB,
    channel INTEGER DEFAULT 1,
    city_id BIGINT DEFAULT 0,
    remark VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_by BIGINT DEFAULT 0,
    updated_by BIGINT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE hg_addon_hgexample_table IS '插件_案例_表格';
COMMENT ON COLUMN hg_addon_hgexample_table.id IS 'ID';
COMMENT ON COLUMN hg_addon_hgexample_table.pid IS '上级ID';
COMMENT ON COLUMN hg_addon_hgexample_table.level IS '树等级';
COMMENT ON COLUMN hg_addon_hgexample_table.tree IS '关系树';
COMMENT ON COLUMN hg_addon_hgexample_table.category_id IS '分类ID';
COMMENT ON COLUMN hg_addon_hgexample_table.flag IS '标签';
COMMENT ON COLUMN hg_addon_hgexample_table.title IS '标题';
COMMENT ON COLUMN hg_addon_hgexample_table.description IS '描述';
COMMENT ON COLUMN hg_addon_hgexample_table.content IS '内容';
COMMENT ON COLUMN hg_addon_hgexample_table.image IS '单图';
COMMENT ON COLUMN hg_addon_hgexample_table.images IS '多图';
COMMENT ON COLUMN hg_addon_hgexample_table.attachfile IS '附件';
COMMENT ON COLUMN hg_addon_hgexample_table.attachfiles IS '多附件';
COMMENT ON COLUMN hg_addon_hgexample_table.map IS '动态键值对';
COMMENT ON COLUMN hg_addon_hgexample_table.star IS '推荐星';
COMMENT ON COLUMN hg_addon_hgexample_table.price IS '价格';
COMMENT ON COLUMN hg_addon_hgexample_table.views IS '浏览次数';
COMMENT ON COLUMN hg_addon_hgexample_table.activity_at IS '活动时间';
COMMENT ON COLUMN hg_addon_hgexample_table.start_at IS '开启时间';
COMMENT ON COLUMN hg_addon_hgexample_table.end_at IS '结束时间';
COMMENT ON COLUMN hg_addon_hgexample_table.switch IS '开关';
COMMENT ON COLUMN hg_addon_hgexample_table.sort IS '排序';
COMMENT ON COLUMN hg_addon_hgexample_table.avatar IS '头像';
COMMENT ON COLUMN hg_addon_hgexample_table.sex IS '性别';
COMMENT ON COLUMN hg_addon_hgexample_table.qq IS 'qq';
COMMENT ON COLUMN hg_addon_hgexample_table.email IS '邮箱';
COMMENT ON COLUMN hg_addon_hgexample_table.mobile IS '手机号码';
COMMENT ON COLUMN hg_addon_hgexample_table.hobby IS '爱好';
COMMENT ON COLUMN hg_addon_hgexample_table.channel IS '渠道';
COMMENT ON COLUMN hg_addon_hgexample_table.city_id IS '所在城市';
COMMENT ON COLUMN hg_addon_hgexample_table.remark IS '备注';
COMMENT ON COLUMN hg_addon_hgexample_table.status IS '状态';
COMMENT ON COLUMN hg_addon_hgexample_table.created_by IS '创建者';
COMMENT ON COLUMN hg_addon_hgexample_table.updated_by IS '更新者';
COMMENT ON COLUMN hg_addon_hgexample_table.created_at IS '创建时间';
COMMENT ON COLUMN hg_addon_hgexample_table.updated_at IS '修改时间';
COMMENT ON COLUMN hg_addon_hgexample_table.deleted_at IS '删除时间';

-- 创建 hg_addon_hgexample_tenant_order 表

CREATE TABLE IF NOT EXISTS hg_addon_hgexample_tenant_order (
    id BIGSERIAL PRIMARY KEY,
    tenant_id BIGINT,
    merchant_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    product_name VARCHAR(255),
    order_sn VARCHAR(64),
    money NUMERIC(10,2) NOT NULL,
    remark VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_addon_hgexample_tenant_order IS '多租户_充值订单';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.id IS '主键';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.tenant_id IS '租户ID';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.merchant_id IS '商户ID';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.user_id IS '用户ID';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.product_name IS '购买产品';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.order_sn IS '订单号';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.money IS '充值金额';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.remark IS '备注';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.status IS '订单状态';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.created_at IS '创建时间';
COMMENT ON COLUMN hg_addon_hgexample_tenant_order.updated_at IS '修改时间';

-- hg_admin_cash

CREATE TABLE IF NOT EXISTS hg_admin_cash (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT NOT NULL,
    money NUMERIC(10,2) NOT NULL,
    fee NUMERIC(10,2) NOT NULL,
    last_money NUMERIC(10,2) NOT NULL,
    ip VARCHAR(128) NOT NULL,
    status BIGINT NOT NULL,
    msg VARCHAR(128) NOT NULL,
    handle_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL
);

COMMENT ON TABLE hg_admin_cash IS '管理员_提现记录表';
COMMENT ON COLUMN hg_admin_cash.id IS 'ID';
COMMENT ON COLUMN hg_admin_cash.member_id IS '管理员ID';
COMMENT ON COLUMN hg_admin_cash.money IS '提现金额';
COMMENT ON COLUMN hg_admin_cash.fee IS '手续费';
COMMENT ON COLUMN hg_admin_cash.last_money IS '最终到账金额';
COMMENT ON COLUMN hg_admin_cash.ip IS '申请人IP';
COMMENT ON COLUMN hg_admin_cash.status IS '状态码';
COMMENT ON COLUMN hg_admin_cash.msg IS '处理结果';
COMMENT ON COLUMN hg_admin_cash.handle_at IS '处理时间';
COMMENT ON COLUMN hg_admin_cash.created_at IS '申请时间';

-- hg_admin_credits_log

CREATE TABLE IF NOT EXISTS hg_admin_credits_log (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT DEFAULT 0,
    app_id VARCHAR(64),
    addons_name VARCHAR(100) DEFAULT '',
    credit_type VARCHAR(32) NOT NULL DEFAULT '',
    credit_group VARCHAR(32),
    before_num NUMERIC(10,2) DEFAULT 0.00,
    num NUMERIC(10,2) DEFAULT 0.00,
    after_num NUMERIC(10,2) DEFAULT 0.00,
    remark VARCHAR(255),
    ip VARCHAR(20),
    map_id BIGINT DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_credits_log IS '管理员_资产变动表';
COMMENT ON COLUMN hg_admin_credits_log.id IS '变动ID';
COMMENT ON COLUMN hg_admin_credits_log.member_id IS '管理员ID';
COMMENT ON COLUMN hg_admin_credits_log.app_id IS '应用id';
COMMENT ON COLUMN hg_admin_credits_log.addons_name IS '插件名称';
COMMENT ON COLUMN hg_admin_credits_log.credit_type IS '变动类型';
COMMENT ON COLUMN hg_admin_credits_log.credit_group IS '变动组别';
COMMENT ON COLUMN hg_admin_credits_log.before_num IS '变动前';
COMMENT ON COLUMN hg_admin_credits_log.num IS '变动数据';
COMMENT ON COLUMN hg_admin_credits_log.after_num IS '变动后';
COMMENT ON COLUMN hg_admin_credits_log.remark IS '备注';
COMMENT ON COLUMN hg_admin_credits_log.ip IS '操作人IP';
COMMENT ON COLUMN hg_admin_credits_log.map_id IS '关联ID';
COMMENT ON COLUMN hg_admin_credits_log.status IS '状态';
COMMENT ON COLUMN hg_admin_credits_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_credits_log.updated_at IS '修改时间';

-- hg_admin_dept

CREATE TABLE IF NOT EXISTS hg_admin_dept (
    id BIGSERIAL PRIMARY KEY,
    pid BIGINT DEFAULT 0,
    name VARCHAR(32),
    code VARCHAR(255),
    type VARCHAR(10),
    leader VARCHAR(32),
    phone VARCHAR(11),
    email VARCHAR(64),
    level INTEGER NOT NULL,
    tree TEXT,
    sort INTEGER DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_dept IS '管理员_部门';
COMMENT ON COLUMN hg_admin_dept.id IS '部门ID';
COMMENT ON COLUMN hg_admin_dept.pid IS '父部门ID';
COMMENT ON COLUMN hg_admin_dept.name IS '部门名称';
COMMENT ON COLUMN hg_admin_dept.code IS '部门编码';
COMMENT ON COLUMN hg_admin_dept.type IS '部门类型';
COMMENT ON COLUMN hg_admin_dept.leader IS '负责人';
COMMENT ON COLUMN hg_admin_dept.phone IS '联系电话';
COMMENT ON COLUMN hg_admin_dept.email IS '邮箱';
COMMENT ON COLUMN hg_admin_dept.level IS '关系树等级';
COMMENT ON COLUMN hg_admin_dept.tree IS '关系树';
COMMENT ON COLUMN hg_admin_dept.sort IS '排序';
COMMENT ON COLUMN hg_admin_dept.status IS '部门状态';
COMMENT ON COLUMN hg_admin_dept.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_dept.updated_at IS '更新时间';

-- hg_admin_member

CREATE TABLE IF NOT EXISTS hg_admin_member (
    id BIGSERIAL PRIMARY KEY,
    dept_id BIGINT DEFAULT 0,
    role_id BIGINT DEFAULT 10,
    real_name VARCHAR(32) DEFAULT '',
    username VARCHAR(20) NOT NULL DEFAULT '',
    password_hash VARCHAR(32) NOT NULL DEFAULT '',
    salt VARCHAR(16) NOT NULL,
    password_reset_token VARCHAR(150) DEFAULT '',
    integral NUMERIC(10,2) DEFAULT 0.00,
    balance NUMERIC(10,2) DEFAULT 0.00,
    avatar VARCHAR(150) DEFAULT '',
    sex SMALLINT DEFAULT 1,
    qq VARCHAR(20) DEFAULT '',
    email VARCHAR(60) DEFAULT '',
    mobile VARCHAR(20) DEFAULT '',
    birthday DATE,
    city_id BIGINT DEFAULT 0,
    address VARCHAR(100) DEFAULT '',
    pid BIGINT NOT NULL,
    level INTEGER DEFAULT 1,
    tree TEXT,
    invite_code VARCHAR(12),
    cash JSONB,
    last_active_at TIMESTAMP,
    remark VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_member IS '管理员_用户表';
COMMENT ON COLUMN hg_admin_member.id IS '管理员ID';
COMMENT ON COLUMN hg_admin_member.dept_id IS '部门ID';
COMMENT ON COLUMN hg_admin_member.role_id IS '角色ID';
COMMENT ON COLUMN hg_admin_member.real_name IS '真实姓名';
COMMENT ON COLUMN hg_admin_member.username IS '帐号';
COMMENT ON COLUMN hg_admin_member.password_hash IS '密码';
COMMENT ON COLUMN hg_admin_member.salt IS '密码盐';
COMMENT ON COLUMN hg_admin_member.password_reset_token IS '密码重置令牌';
COMMENT ON COLUMN hg_admin_member.integral IS '积分';
COMMENT ON COLUMN hg_admin_member.balance IS '余额';
COMMENT ON COLUMN hg_admin_member.avatar IS '头像';
COMMENT ON COLUMN hg_admin_member.sex IS '性别';
COMMENT ON COLUMN hg_admin_member.qq IS 'qq';
COMMENT ON COLUMN hg_admin_member.email IS '邮箱';
COMMENT ON COLUMN hg_admin_member.mobile IS '手机号码';
COMMENT ON COLUMN hg_admin_member.birthday IS '生日';
COMMENT ON COLUMN hg_admin_member.city_id IS '城市编码';
COMMENT ON COLUMN hg_admin_member.address IS '联系地址';
COMMENT ON COLUMN hg_admin_member.pid IS '上级管理员ID';
COMMENT ON COLUMN hg_admin_member.level IS '关系树等级';
COMMENT ON COLUMN hg_admin_member.tree IS '关系树';
COMMENT ON COLUMN hg_admin_member.invite_code IS '邀请码';
COMMENT ON COLUMN hg_admin_member.cash IS '提现配置';
COMMENT ON COLUMN hg_admin_member.last_active_at IS '最后活跃时间';
COMMENT ON COLUMN hg_admin_member.remark IS '备注';
COMMENT ON COLUMN hg_admin_member.status IS '状态';
COMMENT ON COLUMN hg_admin_member.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_member.updated_at IS '修改时间';

-- hg_admin_member_post

CREATE TABLE IF NOT EXISTS hg_admin_member_post (
    member_id BIGINT NOT NULL,
    post_id BIGINT NOT NULL,
    PRIMARY KEY (member_id, post_id)
);

COMMENT ON TABLE hg_admin_member_post IS '管理员_用户岗位关联';
COMMENT ON COLUMN hg_admin_member_post.member_id IS '管理员ID';
COMMENT ON COLUMN hg_admin_member_post.post_id IS '岗位ID';

-- hg_admin_member_role

CREATE TABLE IF NOT EXISTS hg_admin_member_role (
    member_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    PRIMARY KEY (member_id, role_id)
);

COMMENT ON TABLE hg_admin_member_role IS '管理员_用户角色关联';
COMMENT ON COLUMN hg_admin_member_role.member_id IS '管理员ID';
COMMENT ON COLUMN hg_admin_member_role.role_id IS '角色ID';

-- hg_admin_menu

CREATE TABLE IF NOT EXISTS hg_admin_menu (
    id BIGSERIAL PRIMARY KEY,
    pid BIGINT DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    tree TEXT,
    title VARCHAR(64) NOT NULL,
    name VARCHAR(128) NOT NULL,
    path VARCHAR(200),
    icon VARCHAR(128),
    type SMALLINT NOT NULL DEFAULT 1,
    redirect VARCHAR(255),
    permissions VARCHAR(512),
    permission_name VARCHAR(64),
    component VARCHAR(255),
    always_show SMALLINT DEFAULT 0,
    active_menu VARCHAR(255),
    is_root SMALLINT DEFAULT 0,
    is_frame SMALLINT DEFAULT 1,
    frame_src VARCHAR(512),
    keep_alive SMALLINT DEFAULT 0,
    hidden SMALLINT DEFAULT 0,
    affix SMALLINT DEFAULT 0,
    sort INTEGER DEFAULT 0,
    remark VARCHAR(255),
    status SMALLINT DEFAULT 1,
    updated_at TIMESTAMP,
    created_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_menu IS '管理员_菜单权限';
COMMENT ON COLUMN hg_admin_menu.id IS '菜单ID';
COMMENT ON COLUMN hg_admin_menu.pid IS '父菜单ID';
COMMENT ON COLUMN hg_admin_menu.level IS '关系树等级';
COMMENT ON COLUMN hg_admin_menu.tree IS '关系树';
COMMENT ON COLUMN hg_admin_menu.title IS '菜单名称';
COMMENT ON COLUMN hg_admin_menu.name IS '名称编码';
COMMENT ON COLUMN hg_admin_menu.path IS '路由地址';
COMMENT ON COLUMN hg_admin_menu.icon IS '菜单图标';
COMMENT ON COLUMN hg_admin_menu.type IS '菜单类型（1目录 2菜单 3按钮）';
COMMENT ON COLUMN hg_admin_menu.redirect IS '重定向地址';
COMMENT ON COLUMN hg_admin_menu.permissions IS '菜单包含权限集合';
COMMENT ON COLUMN hg_admin_menu.permission_name IS '权限名称';
COMMENT ON COLUMN hg_admin_menu.component IS '组件路径';
COMMENT ON COLUMN hg_admin_menu.always_show IS '取消自动计算根路由模式';
COMMENT ON COLUMN hg_admin_menu.active_menu IS '高亮菜单编码';
COMMENT ON COLUMN hg_admin_menu.is_root IS '是否跟路由';
COMMENT ON COLUMN hg_admin_menu.is_frame IS '是否内嵌';
COMMENT ON COLUMN hg_admin_menu.frame_src IS '内联外部地址';
COMMENT ON COLUMN hg_admin_menu.keep_alive IS '缓存该路由';
COMMENT ON COLUMN hg_admin_menu.hidden IS '是否隐藏';
COMMENT ON COLUMN hg_admin_menu.affix IS '是否固定';
COMMENT ON COLUMN hg_admin_menu.sort IS '排序';
COMMENT ON COLUMN hg_admin_menu.remark IS '备注';
COMMENT ON COLUMN hg_admin_menu.status IS '菜单状态';
COMMENT ON COLUMN hg_admin_menu.updated_at IS '更新时间';
COMMENT ON COLUMN hg_admin_menu.created_at IS '创建时间';

-- hg_admin_notice

CREATE TABLE IF NOT EXISTS hg_admin_notice (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(64) NOT NULL,
    type BIGINT NOT NULL,
    tag INTEGER,
    content TEXT NOT NULL,
    receiver JSONB,
    remark VARCHAR(255),
    sort INTEGER NOT NULL DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_by BIGINT,
    updated_by BIGINT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_notice IS '管理员_通知公告';
COMMENT ON COLUMN hg_admin_notice.id IS '公告ID';
COMMENT ON COLUMN hg_admin_notice.title IS '公告标题';
COMMENT ON COLUMN hg_admin_notice.type IS '公告类型';
COMMENT ON COLUMN hg_admin_notice.tag IS '标签';
COMMENT ON COLUMN hg_admin_notice.content IS '公告内容';
COMMENT ON COLUMN hg_admin_notice.receiver IS '接收者';
COMMENT ON COLUMN hg_admin_notice.remark IS '备注';
COMMENT ON COLUMN hg_admin_notice.sort IS '排序';
COMMENT ON COLUMN hg_admin_notice.status IS '公告状态';
COMMENT ON COLUMN hg_admin_notice.created_by IS '发送人';
COMMENT ON COLUMN hg_admin_notice.updated_by IS '修改人';
COMMENT ON COLUMN hg_admin_notice.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_notice.updated_at IS '更新时间';
COMMENT ON COLUMN hg_admin_notice.deleted_at IS '删除时间';

-- hg_admin_notice_read

CREATE TABLE IF NOT EXISTS hg_admin_notice_read (
    id BIGSERIAL PRIMARY KEY,
    notice_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    clicks INTEGER DEFAULT 1,
    updated_at TIMESTAMP,
    created_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_notice_read IS '管理员_公告已读记录';
COMMENT ON COLUMN hg_admin_notice_read.id IS '记录ID';
COMMENT ON COLUMN hg_admin_notice_read.notice_id IS '公告ID';
COMMENT ON COLUMN hg_admin_notice_read.member_id IS '会员ID';
COMMENT ON COLUMN hg_admin_notice_read.clicks IS '已读次数';
COMMENT ON COLUMN hg_admin_notice_read.updated_at IS '更新时间';
COMMENT ON COLUMN hg_admin_notice_read.created_at IS '阅读时间';

-- hg_admin_oauth

CREATE TABLE IF NOT EXISTS hg_admin_oauth (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT DEFAULT 0,
    unionid VARCHAR(64) DEFAULT '',
    oauth_client VARCHAR(32),
    oauth_openid VARCHAR(128),
    sex SMALLINT DEFAULT 1,
    nickname VARCHAR(255),
    head_portrait VARCHAR(512),
    birthday DATE,
    country VARCHAR(100) DEFAULT '',
    province VARCHAR(100) DEFAULT '',
    city VARCHAR(100) DEFAULT '',
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_oauth IS '管理员_第三方登录';
COMMENT ON COLUMN hg_admin_oauth.id IS '主键';
COMMENT ON COLUMN hg_admin_oauth.member_id IS '用户ID';
COMMENT ON COLUMN hg_admin_oauth.unionid IS '唯一ID';
COMMENT ON COLUMN hg_admin_oauth.oauth_client IS '授权组别';
COMMENT ON COLUMN hg_admin_oauth.oauth_openid IS '授权开放ID';
COMMENT ON COLUMN hg_admin_oauth.sex IS '性别';
COMMENT ON COLUMN hg_admin_oauth.nickname IS '昵称';
COMMENT ON COLUMN hg_admin_oauth.head_portrait IS '头像';
COMMENT ON COLUMN hg_admin_oauth.birthday IS '生日';
COMMENT ON COLUMN hg_admin_oauth.country IS '国家';
COMMENT ON COLUMN hg_admin_oauth.province IS '省';
COMMENT ON COLUMN hg_admin_oauth.city IS '市';
COMMENT ON COLUMN hg_admin_oauth.status IS '状态';
COMMENT ON COLUMN hg_admin_oauth.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_oauth.updated_at IS '修改时间';

-- hg_admin_order

CREATE TABLE IF NOT EXISTS hg_admin_order (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT DEFAULT 0,
    order_type VARCHAR(32) NOT NULL,
    product_id BIGINT,
    order_sn VARCHAR(64) DEFAULT '',
    money NUMERIC(10,2) NOT NULL,
    remark VARCHAR(255),
    refund_reason VARCHAR(255),
    reject_refund_reason VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_order IS '管理员_充值订单';
COMMENT ON COLUMN hg_admin_order.id IS '主键';
COMMENT ON COLUMN hg_admin_order.member_id IS '管理员id';
COMMENT ON COLUMN hg_admin_order.order_type IS '订单类型';
COMMENT ON COLUMN hg_admin_order.product_id IS '产品id';
COMMENT ON COLUMN hg_admin_order.order_sn IS '关联订单号';
COMMENT ON COLUMN hg_admin_order.money IS '充值金额';
COMMENT ON COLUMN hg_admin_order.remark IS '备注';
COMMENT ON COLUMN hg_admin_order.refund_reason IS '退款原因';
COMMENT ON COLUMN hg_admin_order.reject_refund_reason IS '拒绝退款原因';
COMMENT ON COLUMN hg_admin_order.status IS '状态';
COMMENT ON COLUMN hg_admin_order.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_order.updated_at IS '修改时间';

-- hg_admin_post

CREATE TABLE IF NOT EXISTS hg_admin_post (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(64) NOT NULL,
    name VARCHAR(50) NOT NULL,
    remark VARCHAR(500),
    sort INTEGER NOT NULL,
    status SMALLINT NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_post IS '管理员_岗位';
COMMENT ON COLUMN hg_admin_post.id IS '岗位ID';
COMMENT ON COLUMN hg_admin_post.code IS '岗位编码';
COMMENT ON COLUMN hg_admin_post.name IS '岗位名称';
COMMENT ON COLUMN hg_admin_post.remark IS '备注';
COMMENT ON COLUMN hg_admin_post.sort IS '排序';
COMMENT ON COLUMN hg_admin_post.status IS '状态';
COMMENT ON COLUMN hg_admin_post.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_post.updated_at IS '更新时间';

-- hg_admin_role

CREATE TABLE IF NOT EXISTS hg_admin_role (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    key VARCHAR(128) NOT NULL,
    data_scope SMALLINT DEFAULT 1,
    custom_dept JSONB,
    pid BIGINT DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    tree TEXT,
    remark VARCHAR(255),
    sort INTEGER NOT NULL DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_admin_role IS '管理员_角色信息';
COMMENT ON COLUMN hg_admin_role.id IS '角色ID';
COMMENT ON COLUMN hg_admin_role.name IS '角色名称';
COMMENT ON COLUMN hg_admin_role.key IS '角色权限字符串';
COMMENT ON COLUMN hg_admin_role.data_scope IS '数据范围';
COMMENT ON COLUMN hg_admin_role.custom_dept IS '自定义部门权限';
COMMENT ON COLUMN hg_admin_role.pid IS '上级角色ID';
COMMENT ON COLUMN hg_admin_role.level IS '关系树等级';
COMMENT ON COLUMN hg_admin_role.tree IS '关系树';
COMMENT ON COLUMN hg_admin_role.remark IS '备注';
COMMENT ON COLUMN hg_admin_role.sort IS '排序';
COMMENT ON COLUMN hg_admin_role.status IS '角色状态';
COMMENT ON COLUMN hg_admin_role.created_at IS '创建时间';
COMMENT ON COLUMN hg_admin_role.updated_at IS '更新时间';

-- hg_admin_role_casbin

CREATE TABLE IF NOT EXISTS hg_admin_role_casbin (
    id BIGSERIAL PRIMARY KEY,
    p_type VARCHAR(64),
    v0 VARCHAR(256),
    v1 VARCHAR(256),
    v2 VARCHAR(256),
    v3 VARCHAR(256),
    v4 VARCHAR(256),
    v5 VARCHAR(256)
);

COMMENT ON TABLE hg_admin_role_casbin IS '管理员_casbin权限表';

-- hg_admin_role_menu

CREATE TABLE IF NOT EXISTS hg_admin_role_menu (
    role_id BIGINT NOT NULL,
    menu_id BIGINT NOT NULL,
    PRIMARY KEY (role_id, menu_id)
);

COMMENT ON TABLE hg_admin_role_menu IS '管理员_角色菜单关联';
COMMENT ON COLUMN hg_admin_role_menu.role_id IS '角色ID';
COMMENT ON COLUMN hg_admin_role_menu.menu_id IS '菜单ID';

-- hg_pay_log

CREATE TABLE IF NOT EXISTS hg_pay_log (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT DEFAULT 0,
    app_id VARCHAR(50),
    addons_name VARCHAR(100) DEFAULT '',
    order_sn VARCHAR(64) DEFAULT '',
    order_group VARCHAR(32) DEFAULT '',
    openid VARCHAR(50) DEFAULT '',
    mch_id VARCHAR(20) DEFAULT '',
    subject VARCHAR(255),
    detail JSONB,
    auth_code VARCHAR(50) DEFAULT '',
    out_trade_no VARCHAR(128) DEFAULT '',
    transaction_id VARCHAR(128),
    pay_type VARCHAR(32) NOT NULL,
    pay_amount NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    actual_amount NUMERIC(10,2),
    pay_status SMALLINT DEFAULT 0,
    pay_at TIMESTAMP,
    trade_type VARCHAR(16) DEFAULT '',
    refund_sn VARCHAR(128),
    is_refund SMALLINT DEFAULT 0,
    custom TEXT,
    create_ip VARCHAR(128),
    pay_ip VARCHAR(128),
    notify_url VARCHAR(255),
    return_url VARCHAR(255),
    trace_ids JSONB,
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_pay_log IS '支付_支付日志';
COMMENT ON COLUMN hg_pay_log.id IS '主键';
COMMENT ON COLUMN hg_pay_log.member_id IS '会员ID';
COMMENT ON COLUMN hg_pay_log.app_id IS '应用ID';
COMMENT ON COLUMN hg_pay_log.addons_name IS '插件名称';
COMMENT ON COLUMN hg_pay_log.order_sn IS '关联订单号';
COMMENT ON COLUMN hg_pay_log.order_group IS '组别[默认统一支付类型]';
COMMENT ON COLUMN hg_pay_log.openid IS 'openid';
COMMENT ON COLUMN hg_pay_log.mch_id IS '商户支付账户';
COMMENT ON COLUMN hg_pay_log.subject IS '订单标题';
COMMENT ON COLUMN hg_pay_log.detail IS '支付商品详情';
COMMENT ON COLUMN hg_pay_log.auth_code IS '刷卡码';
COMMENT ON COLUMN hg_pay_log.out_trade_no IS '商户订单号';
COMMENT ON COLUMN hg_pay_log.transaction_id IS '交易号';
COMMENT ON COLUMN hg_pay_log.pay_type IS '支付类型';
COMMENT ON COLUMN hg_pay_log.pay_amount IS '支付金额';
COMMENT ON COLUMN hg_pay_log.actual_amount IS '实付金额';
COMMENT ON COLUMN hg_pay_log.pay_status IS '支付状态';
COMMENT ON COLUMN hg_pay_log.pay_at IS '支付时间';
COMMENT ON COLUMN hg_pay_log.trade_type IS '交易类型';
COMMENT ON COLUMN hg_pay_log.refund_sn IS '退款单号';
COMMENT ON COLUMN hg_pay_log.is_refund IS '是否退款';
COMMENT ON COLUMN hg_pay_log.custom IS '自定义参数';
COMMENT ON COLUMN hg_pay_log.create_ip IS '创建者IP';
COMMENT ON COLUMN hg_pay_log.pay_ip IS '支付者IP';
COMMENT ON COLUMN hg_pay_log.notify_url IS '支付通知回调地址';
COMMENT ON COLUMN hg_pay_log.return_url IS '买家付款成功跳转地址';
COMMENT ON COLUMN hg_pay_log.trace_ids IS '链路ID集合';
COMMENT ON COLUMN hg_pay_log.status IS '状态';
COMMENT ON COLUMN hg_pay_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_pay_log.updated_at IS '修改时间';

-- hg_pay_refund

CREATE TABLE IF NOT EXISTS hg_pay_refund (
    id BIGSERIAL PRIMARY KEY,
    member_id BIGINT DEFAULT 0,
    app_id VARCHAR(32),
    order_sn VARCHAR(64),
    refund_trade_no VARCHAR(128),
    refund_money NUMERIC(10,2),
    refund_way SMALLINT DEFAULT 1,
    ip VARCHAR(30),
    reason VARCHAR(255),
    remark VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_pay_refund IS '支付_退款记录';
COMMENT ON COLUMN hg_pay_refund.id IS '主键ID';
COMMENT ON COLUMN hg_pay_refund.member_id IS '会员ID';
COMMENT ON COLUMN hg_pay_refund.app_id IS '应用ID';
COMMENT ON COLUMN hg_pay_refund.order_sn IS '业务订单号';
COMMENT ON COLUMN hg_pay_refund.refund_trade_no IS '退款交易号';
COMMENT ON COLUMN hg_pay_refund.refund_money IS '退款金额';
COMMENT ON COLUMN hg_pay_refund.refund_way IS '退款方式';
COMMENT ON COLUMN hg_pay_refund.ip IS '申请者IP';
COMMENT ON COLUMN hg_pay_refund.reason IS '申请退款原因';
COMMENT ON COLUMN hg_pay_refund.remark IS '退款备注';
COMMENT ON COLUMN hg_pay_refund.status IS '退款状态';
COMMENT ON COLUMN hg_pay_refund.created_at IS '申请时间';
COMMENT ON COLUMN hg_pay_refund.updated_at IS '更新时间';

-- hg_sys_addons_config

CREATE TABLE IF NOT EXISTS hg_sys_addons_config (
    id BIGSERIAL PRIMARY KEY,
    addon_name VARCHAR(128) NOT NULL,
    "group" VARCHAR(128) NOT NULL,
    name VARCHAR(100) DEFAULT '',
    type VARCHAR(32) NOT NULL,
    key VARCHAR(100) DEFAULT '',
    value VARCHAR(500) DEFAULT '',
    default_value VARCHAR(500) NOT NULL,
    sort INTEGER NOT NULL DEFAULT 0,
    tip VARCHAR(500),
    is_default SMALLINT DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_addons_config IS '系统_插件配置';
COMMENT ON COLUMN hg_sys_addons_config.id IS '配置ID';
COMMENT ON COLUMN hg_sys_addons_config.addon_name IS '插件名称';
COMMENT ON COLUMN hg_sys_addons_config.group IS '分组';
COMMENT ON COLUMN hg_sys_addons_config.name IS '参数名称';
COMMENT ON COLUMN hg_sys_addons_config.type IS '键值类型:string,int,uint,bool,TIMESTAMP,date';
COMMENT ON COLUMN hg_sys_addons_config.key IS '参数键名';
COMMENT ON COLUMN hg_sys_addons_config.value IS '参数键值';
COMMENT ON COLUMN hg_sys_addons_config.default_value IS '默认值';
COMMENT ON COLUMN hg_sys_addons_config.sort IS '排序';
COMMENT ON COLUMN hg_sys_addons_config.tip IS '变量描述';
COMMENT ON COLUMN hg_sys_addons_config.is_default IS '是否为系统默认';
COMMENT ON COLUMN hg_sys_addons_config.status IS '状态';
COMMENT ON COLUMN hg_sys_addons_config.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_addons_config.updated_at IS '更新时间';

-- hg_sys_addons_install

CREATE TABLE IF NOT EXISTS hg_sys_addons_install (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    version VARCHAR(128) NOT NULL DEFAULT '',
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_addons_install IS '系统_插件安装记录';
COMMENT ON COLUMN hg_sys_addons_install.id IS '主键';
COMMENT ON COLUMN hg_sys_addons_install.name IS '插件名称';
COMMENT ON COLUMN hg_sys_addons_install.version IS '版本号';
COMMENT ON COLUMN hg_sys_addons_install.status IS '状态';
COMMENT ON COLUMN hg_sys_addons_install.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_addons_install.updated_at IS '更新时间';

-- hg_sys_attachment

CREATE TABLE IF NOT EXISTS hg_sys_attachment (
    id BIGSERIAL PRIMARY KEY,
    app_id VARCHAR(64) NOT NULL,
    member_id BIGINT DEFAULT 0,
    cate_id BIGINT DEFAULT 0,
    drive VARCHAR(64),
    name VARCHAR(1000),
    kind VARCHAR(16),
    mime_type VARCHAR(128) NOT NULL DEFAULT '',
    naive_type VARCHAR(32),
    path VARCHAR(1000),
    file_url VARCHAR(1000),
    size BIGINT DEFAULT 0,
    ext VARCHAR(50),
    md5 VARCHAR(32),
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_attachment IS '系统_附件管理';
COMMENT ON COLUMN hg_sys_attachment.id IS '文件ID';
COMMENT ON COLUMN hg_sys_attachment.app_id IS '应用ID';
COMMENT ON COLUMN hg_sys_attachment.member_id IS '管理员ID';
COMMENT ON COLUMN hg_sys_attachment.cate_id IS '上传分类';
COMMENT ON COLUMN hg_sys_attachment.drive IS '上传驱动';
COMMENT ON COLUMN hg_sys_attachment.name IS '文件原始名';
COMMENT ON COLUMN hg_sys_attachment.kind IS '上传类型';
COMMENT ON COLUMN hg_sys_attachment.mime_type IS '扩展类型';
COMMENT ON COLUMN hg_sys_attachment.naive_type IS 'NaiveUI类型';
COMMENT ON COLUMN hg_sys_attachment.path IS '本地路径';
COMMENT ON COLUMN hg_sys_attachment.file_url IS 'url';
COMMENT ON COLUMN hg_sys_attachment.size IS '文件大小';
COMMENT ON COLUMN hg_sys_attachment.ext IS '扩展名';
COMMENT ON COLUMN hg_sys_attachment.md5 IS 'md5校验码';
COMMENT ON COLUMN hg_sys_attachment.status IS '状态';
COMMENT ON COLUMN hg_sys_attachment.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_attachment.updated_at IS '修改时间';

-- hg_sys_blacklist

CREATE TABLE IF NOT EXISTS hg_sys_blacklist (
    id BIGSERIAL PRIMARY KEY,
    ip VARCHAR(100) DEFAULT '',
    remark VARCHAR(500),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_blacklist IS '系统_访问黑名单';
COMMENT ON COLUMN hg_sys_blacklist.id IS '黑名单ID';
COMMENT ON COLUMN hg_sys_blacklist.ip IS 'IP地址';
COMMENT ON COLUMN hg_sys_blacklist.remark IS '备注';
COMMENT ON COLUMN hg_sys_blacklist.status IS '状态';
COMMENT ON COLUMN hg_sys_blacklist.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_blacklist.updated_at IS '更新时间';

-- hg_sys_config

CREATE TABLE IF NOT EXISTS hg_sys_config (
    id BIGSERIAL PRIMARY KEY,
    "group" VARCHAR(128) NOT NULL,
    name VARCHAR(100) DEFAULT '',
    type VARCHAR(32) NOT NULL,
    key VARCHAR(100) DEFAULT '',
    value TEXT,
    default_value VARCHAR(500) NOT NULL,
    sort INTEGER NOT NULL DEFAULT 0,
    tip VARCHAR(500),
    is_default SMALLINT DEFAULT 0,
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_config IS '系统_配置';
COMMENT ON COLUMN hg_sys_config.id IS '配置ID';
COMMENT ON COLUMN hg_sys_config.group IS '配置分组';
COMMENT ON COLUMN hg_sys_config.name IS '参数名称';
COMMENT ON COLUMN hg_sys_config.type IS '键值类型:string,int,uint,bool,TIMESTAMP,date';
COMMENT ON COLUMN hg_sys_config.key IS '参数键名';
COMMENT ON COLUMN hg_sys_config.value IS '参数键值';
COMMENT ON COLUMN hg_sys_config.default_value IS '默认值';
COMMENT ON COLUMN hg_sys_config.sort IS '排序';
COMMENT ON COLUMN hg_sys_config.tip IS '变量描述';
COMMENT ON COLUMN hg_sys_config.is_default IS '是否为系统默认';
COMMENT ON COLUMN hg_sys_config.status IS '状态';
COMMENT ON COLUMN hg_sys_config.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_config.updated_at IS '更新时间';

-- hg_sys_cron

CREATE TABLE IF NOT EXISTS hg_sys_cron (
    id BIGSERIAL PRIMARY KEY,
    "group_id" BIGINT NOT NULL,
    title VARCHAR(128) NOT NULL,
    name VARCHAR(100),
    params VARCHAR(255),
    pattern VARCHAR(64) NOT NULL,
    policy BIGINT NOT NULL DEFAULT 1,
    count BIGINT NOT NULL DEFAULT 0,
    sort INTEGER DEFAULT 0,
    remark VARCHAR(500),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_cron IS '系统_定时任务';
COMMENT ON COLUMN hg_sys_cron.id IS '任务ID';
COMMENT ON COLUMN hg_sys_cron.group_id IS '分组ID';
COMMENT ON COLUMN hg_sys_cron.title IS '任务标题';
COMMENT ON COLUMN hg_sys_cron.name IS '任务方法';
COMMENT ON COLUMN hg_sys_cron.params IS '函数参数';
COMMENT ON COLUMN hg_sys_cron.pattern IS '表达式';
COMMENT ON COLUMN hg_sys_cron.policy IS '策略';
COMMENT ON COLUMN hg_sys_cron.count IS '执行次数';
COMMENT ON COLUMN hg_sys_cron.sort IS '排序';
COMMENT ON COLUMN hg_sys_cron.remark IS '备注';
COMMENT ON COLUMN hg_sys_cron.status IS '任务状态';
COMMENT ON COLUMN hg_sys_cron.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_cron.updated_at IS '更新时间';

-- hg_sys_cron_group

CREATE TABLE IF NOT EXISTS hg_sys_cron_group (
    id BIGSERIAL PRIMARY KEY,
    pid BIGINT NOT NULL DEFAULT 0,
    name VARCHAR(100) DEFAULT '',
    is_default SMALLINT DEFAULT 0,
    sort INTEGER DEFAULT 0,
    remark VARCHAR(500),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_cron_group IS '系统_定时任务分组';
COMMENT ON COLUMN hg_sys_cron_group.id IS '任务分组ID';
COMMENT ON COLUMN hg_sys_cron_group.pid IS '父类任务分组ID';
COMMENT ON COLUMN hg_sys_cron_group.name IS '分组名称';
COMMENT ON COLUMN hg_sys_cron_group.is_default IS '是否默认';
COMMENT ON COLUMN hg_sys_cron_group.sort IS '排序';
COMMENT ON COLUMN hg_sys_cron_group.remark IS '备注';
COMMENT ON COLUMN hg_sys_cron_group.status IS '分组状态';
COMMENT ON COLUMN hg_sys_cron_group.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_cron_group.updated_at IS '更新时间';

-- hg_sys_dict_data

CREATE TABLE IF NOT EXISTS hg_sys_dict_data (
    id BIGSERIAL PRIMARY KEY,
    label VARCHAR(100),
    value VARCHAR(100),
    value_type VARCHAR(255) NOT NULL DEFAULT 'string',
    type VARCHAR(100),
    list_class VARCHAR(100),
    is_default SMALLINT DEFAULT 2,
    sort INTEGER DEFAULT 0,
    remark VARCHAR(500),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_dict_data IS '系统_字典数据';
COMMENT ON COLUMN hg_sys_dict_data.id IS '字典数据ID';
COMMENT ON COLUMN hg_sys_dict_data.label IS '字典标签';
COMMENT ON COLUMN hg_sys_dict_data.value IS '字典键值';
COMMENT ON COLUMN hg_sys_dict_data.value_type IS '键值数据类型：string,int,uint,bool,TIMESTAMP,date';
COMMENT ON COLUMN hg_sys_dict_data.type IS '字典类型';
COMMENT ON COLUMN hg_sys_dict_data.list_class IS '表格回显样式';
COMMENT ON COLUMN hg_sys_dict_data.is_default IS '是否为系统默认';
COMMENT ON COLUMN hg_sys_dict_data.sort IS '字典排序';
COMMENT ON COLUMN hg_sys_dict_data.remark IS '备注';
COMMENT ON COLUMN hg_sys_dict_data.status IS '状态';
COMMENT ON COLUMN hg_sys_dict_data.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_dict_data.updated_at IS '更新时间';

-- hg_sys_dict_type

CREATE TABLE IF NOT EXISTS hg_sys_dict_type (
    id BIGSERIAL PRIMARY KEY,
    pid BIGINT NOT NULL DEFAULT 0,
    name VARCHAR(100) DEFAULT '',
    type VARCHAR(100) DEFAULT '',
    sort INTEGER DEFAULT 0,
    remark VARCHAR(500),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_dict_type IS '系统_字典类型';
COMMENT ON COLUMN hg_sys_dict_type.id IS '字典类型ID';
COMMENT ON COLUMN hg_sys_dict_type.pid IS '父类字典类型ID';
COMMENT ON COLUMN hg_sys_dict_type.name IS '字典类型名称';
COMMENT ON COLUMN hg_sys_dict_type.type IS '字典类型';
COMMENT ON COLUMN hg_sys_dict_type.sort IS '排序';
COMMENT ON COLUMN hg_sys_dict_type.remark IS '备注';
COMMENT ON COLUMN hg_sys_dict_type.status IS '字典类型状态';
COMMENT ON COLUMN hg_sys_dict_type.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_dict_type.updated_at IS '更新时间';

-- hg_sys_ems_log

CREATE TABLE IF NOT EXISTS hg_sys_ems_log (
    id BIGSERIAL PRIMARY KEY,
    event VARCHAR(64) NOT NULL,
    email VARCHAR(512) NOT NULL,
    code VARCHAR(256) DEFAULT '',
    times BIGINT NOT NULL,
    content TEXT,
    ip VARCHAR(128),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_ems_log IS '系统_邮件发送记录';
COMMENT ON COLUMN hg_sys_ems_log.id IS '主键';
COMMENT ON COLUMN hg_sys_ems_log.event IS '事件';
COMMENT ON COLUMN hg_sys_ems_log.email IS '邮箱地址，多个用;隔开';
COMMENT ON COLUMN hg_sys_ems_log.code IS '验证码';
COMMENT ON COLUMN hg_sys_ems_log.times IS '验证次数';
COMMENT ON COLUMN hg_sys_ems_log.content IS '邮件内容';
COMMENT ON COLUMN hg_sys_ems_log.ip IS 'ip地址';
COMMENT ON COLUMN hg_sys_ems_log.status IS '状态(1未验证,2已验证)';
COMMENT ON COLUMN hg_sys_ems_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_ems_log.updated_at IS '更新时间';

-- hg_sys_gen_codes

CREATE TABLE IF NOT EXISTS hg_sys_gen_codes (
    id BIGSERIAL PRIMARY KEY,
    gen_type INTEGER NOT NULL,
    gen_template INTEGER DEFAULT 0,
    var_name VARCHAR(255) NOT NULL,
    options JSONB,
    db_name VARCHAR(128),
    table_name VARCHAR(255) NOT NULL,
    table_comment VARCHAR(255),
    dao_name VARCHAR(255),
    master_columns JSONB,
    addon_name VARCHAR(128),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_gen_codes IS '系统_代码生成记录';
COMMENT ON COLUMN hg_sys_gen_codes.id IS '生成ID';
COMMENT ON COLUMN hg_sys_gen_codes.gen_type IS '生成类型';
COMMENT ON COLUMN hg_sys_gen_codes.gen_template IS '生成模板';
COMMENT ON COLUMN hg_sys_gen_codes.var_name IS '实体命名';
COMMENT ON COLUMN hg_sys_gen_codes.options IS '配置选项';
COMMENT ON COLUMN hg_sys_gen_codes.db_name IS '数据库名称';
COMMENT ON COLUMN hg_sys_gen_codes.table_name IS '主表名称';
COMMENT ON COLUMN hg_sys_gen_codes.table_comment IS '主表注释';
COMMENT ON COLUMN hg_sys_gen_codes.dao_name IS '主表dao模型';
COMMENT ON COLUMN hg_sys_gen_codes.master_columns IS '主表字段';
COMMENT ON COLUMN hg_sys_gen_codes.addon_name IS '插件名称';
COMMENT ON COLUMN hg_sys_gen_codes.status IS '生成状态';
COMMENT ON COLUMN hg_sys_gen_codes.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_gen_codes.updated_at IS '更新时间';

-- hg_sys_gen_curd_demo

CREATE TABLE IF NOT EXISTS hg_sys_gen_curd_demo (
    id BIGSERIAL PRIMARY KEY,
    category_id BIGINT DEFAULT 0,
    title VARCHAR(64) NOT NULL,
    description VARCHAR(255) DEFAULT '',
    content TEXT,
    image VARCHAR(255),
    attachfile VARCHAR(255),
    city_id BIGINT DEFAULT 0,
    switch SMALLINT DEFAULT 1,
    sort INTEGER,
    status SMALLINT DEFAULT 1,
    created_by BIGINT DEFAULT 0,
    updated_by BIGINT DEFAULT 0,
    deleted_by BIGINT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_gen_curd_demo IS '系统_生成curd演示';
COMMENT ON COLUMN hg_sys_gen_curd_demo.id IS 'ID';
COMMENT ON COLUMN hg_sys_gen_curd_demo.category_id IS '分类ID';
COMMENT ON COLUMN hg_sys_gen_curd_demo.title IS '标题';
COMMENT ON COLUMN hg_sys_gen_curd_demo.description IS '描述';
COMMENT ON COLUMN hg_sys_gen_curd_demo.content IS '内容';
COMMENT ON COLUMN hg_sys_gen_curd_demo.image IS '单图';
COMMENT ON COLUMN hg_sys_gen_curd_demo.attachfile IS '附件';
COMMENT ON COLUMN hg_sys_gen_curd_demo.city_id IS '所在城市';
COMMENT ON COLUMN hg_sys_gen_curd_demo.switch IS '显示开关';
COMMENT ON COLUMN hg_sys_gen_curd_demo.sort IS '排序';
COMMENT ON COLUMN hg_sys_gen_curd_demo.status IS '状态';
COMMENT ON COLUMN hg_sys_gen_curd_demo.created_by IS '创建者';
COMMENT ON COLUMN hg_sys_gen_curd_demo.updated_by IS '更新者';
COMMENT ON COLUMN hg_sys_gen_curd_demo.deleted_by IS '删除者';
COMMENT ON COLUMN hg_sys_gen_curd_demo.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_gen_curd_demo.updated_at IS '修改时间';
COMMENT ON COLUMN hg_sys_gen_curd_demo.deleted_at IS '删除时间';

-- hg_sys_gen_tree_demo

CREATE TABLE IF NOT EXISTS hg_sys_gen_tree_demo (
    id BIGSERIAL PRIMARY KEY,
    pid BIGINT,
    level INTEGER DEFAULT 1,
    tree VARCHAR(512),
    category_id BIGINT DEFAULT 0,
    title VARCHAR(64) NOT NULL,
    description VARCHAR(255),
    sort INTEGER,
    status SMALLINT DEFAULT 1,
    created_by BIGINT DEFAULT 0,
    updated_by BIGINT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_gen_tree_demo IS '系统_生成树表演示';
COMMENT ON COLUMN hg_sys_gen_tree_demo.id IS 'ID';
COMMENT ON COLUMN hg_sys_gen_tree_demo.pid IS '上级ID';
COMMENT ON COLUMN hg_sys_gen_tree_demo.level IS '关系树级别';
COMMENT ON COLUMN hg_sys_gen_tree_demo.tree IS '关系树';
COMMENT ON COLUMN hg_sys_gen_tree_demo.category_id IS '分类ID';
COMMENT ON COLUMN hg_sys_gen_tree_demo.title IS '标题';
COMMENT ON COLUMN hg_sys_gen_tree_demo.description IS '描述';
COMMENT ON COLUMN hg_sys_gen_tree_demo.sort IS '排序';
COMMENT ON COLUMN hg_sys_gen_tree_demo.status IS '状态';
COMMENT ON COLUMN hg_sys_gen_tree_demo.created_by IS '创建者';
COMMENT ON COLUMN hg_sys_gen_tree_demo.updated_by IS '更新者';
COMMENT ON COLUMN hg_sys_gen_tree_demo.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_gen_tree_demo.updated_at IS '修改时间';
COMMENT ON COLUMN hg_sys_gen_tree_demo.deleted_at IS '删除时间';

-- hg_sys_log

CREATE TABLE IF NOT EXISTS hg_sys_log (
    id BIGSERIAL PRIMARY KEY,
    req_id VARCHAR(50),
    app_id VARCHAR(50) DEFAULT '',
    merchant_id BIGINT DEFAULT 0,
    member_id BIGINT DEFAULT 0,
    method VARCHAR(20),
    module VARCHAR(50),
    url VARCHAR(1000),
    get_data JSONB,
    post_data JSONB,
    header_data JSONB,
    ip VARCHAR(128),
    province_id BIGINT NOT NULL DEFAULT 0,
    city_id BIGINT NOT NULL DEFAULT 0,
    error_code INTEGER DEFAULT 0,
    error_msg TEXT,
    error_data JSONB,
    user_agent VARCHAR(512),
    take_up_time BIGINT DEFAULT 0,
    timestamp BIGINT DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_log IS '系统_全局日志';
COMMENT ON COLUMN hg_sys_log.id IS '日志ID';
COMMENT ON COLUMN hg_sys_log.req_id IS '对外ID';
COMMENT ON COLUMN hg_sys_log.app_id IS '应用ID';
COMMENT ON COLUMN hg_sys_log.merchant_id IS '商户ID';
COMMENT ON COLUMN hg_sys_log.member_id IS '用户ID';
COMMENT ON COLUMN hg_sys_log.method IS '提交类型';
COMMENT ON COLUMN hg_sys_log.module IS '访问模块';
COMMENT ON COLUMN hg_sys_log.url IS '提交url';
COMMENT ON COLUMN hg_sys_log.get_data IS 'get数据';
COMMENT ON COLUMN hg_sys_log.post_data IS 'post数据';
COMMENT ON COLUMN hg_sys_log.header_data IS 'header数据';
COMMENT ON COLUMN hg_sys_log.ip IS 'IP地址';
COMMENT ON COLUMN hg_sys_log.province_id IS '省编码';
COMMENT ON COLUMN hg_sys_log.city_id IS '市编码';
COMMENT ON COLUMN hg_sys_log.error_code IS '报错code';
COMMENT ON COLUMN hg_sys_log.error_msg IS '对外错误提示';
COMMENT ON COLUMN hg_sys_log.error_data IS '报错日志';
COMMENT ON COLUMN hg_sys_log.user_agent IS 'UA信息';
COMMENT ON COLUMN hg_sys_log.take_up_time IS '请求耗时';
COMMENT ON COLUMN hg_sys_log.timestamp IS '响应时间';
COMMENT ON COLUMN hg_sys_log.status IS '状态';
COMMENT ON COLUMN hg_sys_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_log.updated_at IS '修改时间';

-- hg_sys_login_log

CREATE TABLE IF NOT EXISTS hg_sys_login_log (
    id BIGSERIAL PRIMARY KEY,
    req_id VARCHAR(50),
    member_id BIGINT DEFAULT 0,
    username VARCHAR(64),
    response JSONB,
    login_at TIMESTAMP,
    login_ip VARCHAR(128),
    province_id BIGINT,
    city_id BIGINT,
    user_agent VARCHAR(512),
    err_msg VARCHAR(1000),
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_login_log IS '系统_登录日志';
COMMENT ON COLUMN hg_sys_login_log.id IS '日志ID';
COMMENT ON COLUMN hg_sys_login_log.req_id IS '请求ID';
COMMENT ON COLUMN hg_sys_login_log.member_id IS '用户ID';
COMMENT ON COLUMN hg_sys_login_log.username IS '用户名';
COMMENT ON COLUMN hg_sys_login_log.response IS '响应数据';
COMMENT ON COLUMN hg_sys_login_log.login_at IS '登录时间';
COMMENT ON COLUMN hg_sys_login_log.login_ip IS '登录IP';
COMMENT ON COLUMN hg_sys_login_log.province_id IS '省编码';
COMMENT ON COLUMN hg_sys_login_log.city_id IS '市编码';
COMMENT ON COLUMN hg_sys_login_log.user_agent IS 'UA信息';
COMMENT ON COLUMN hg_sys_login_log.err_msg IS '错误提示';
COMMENT ON COLUMN hg_sys_login_log.status IS '状态';
COMMENT ON COLUMN hg_sys_login_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_login_log.updated_at IS '修改时间';

-- hg_sys_provinces

CREATE TABLE IF NOT EXISTS hg_sys_provinces (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR(50) NOT NULL DEFAULT '',
    pinyin VARCHAR(100) DEFAULT '',
    lng VARCHAR(20) DEFAULT '',
    lat VARCHAR(20) DEFAULT '',
    pid BIGINT NOT NULL DEFAULT 0,
    level INTEGER NOT NULL DEFAULT 1,
    tree TEXT,
    sort INTEGER DEFAULT 0,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_provinces IS '系统_省市区编码';
COMMENT ON COLUMN hg_sys_provinces.id IS '省市区ID';
COMMENT ON COLUMN hg_sys_provinces.title IS '栏目名称';
COMMENT ON COLUMN hg_sys_provinces.pinyin IS '拼音';
COMMENT ON COLUMN hg_sys_provinces.lng IS '经度';
COMMENT ON COLUMN hg_sys_provinces.lat IS '纬度';
COMMENT ON COLUMN hg_sys_provinces.pid IS '父栏目';
COMMENT ON COLUMN hg_sys_provinces.level IS '关系树等级';
COMMENT ON COLUMN hg_sys_provinces.tree IS '关系';
COMMENT ON COLUMN hg_sys_provinces.sort IS '排序';
COMMENT ON COLUMN hg_sys_provinces.status IS '状态';
COMMENT ON COLUMN hg_sys_provinces.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_provinces.updated_at IS '更新时间';

CREATE TABLE IF NOT EXISTS hg_sys_serve_license (
    id BIGSERIAL PRIMARY KEY,
    "group" VARCHAR(50) NOT NULL,
    name VARCHAR(128) NOT NULL,
    appid VARCHAR(64) NOT NULL,
    secret_key VARCHAR(255),
    remote_addr VARCHAR(64),
    online_limit INTEGER DEFAULT 1,
    login_times BIGINT,
    last_login_at TIMESTAMP,
    last_active_at TIMESTAMP,
    routes JSONB,
    allowed_ips VARCHAR(512),
    end_at TIMESTAMP NOT NULL,
    remark VARCHAR(512),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_serve_license IS '系统_服务许可证';
COMMENT ON COLUMN hg_sys_serve_license.id IS '许可ID';
COMMENT ON COLUMN hg_sys_serve_license."group" IS '分组';
COMMENT ON COLUMN hg_sys_serve_license.name IS '许可名称';
COMMENT ON COLUMN hg_sys_serve_license.appid IS '应用ID';
COMMENT ON COLUMN hg_sys_serve_license.secret_key IS '应用秘钥';
COMMENT ON COLUMN hg_sys_serve_license.remote_addr IS '最后连接地址';
COMMENT ON COLUMN hg_sys_serve_license.online_limit IS '在线限制';
COMMENT ON COLUMN hg_sys_serve_license.login_times IS '登录次数';
COMMENT ON COLUMN hg_sys_serve_license.last_login_at IS '最后登录时间';
COMMENT ON COLUMN hg_sys_serve_license.last_active_at IS '最后心跳';
COMMENT ON COLUMN hg_sys_serve_license.routes IS '路由表，空使用默认分组路由';
COMMENT ON COLUMN hg_sys_serve_license.allowed_ips IS 'IP白名单';
COMMENT ON COLUMN hg_sys_serve_license.end_at IS '授权有效期';
COMMENT ON COLUMN hg_sys_serve_license.remark IS '备注';
COMMENT ON COLUMN hg_sys_serve_license.status IS '状态';
COMMENT ON COLUMN hg_sys_serve_license.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_serve_license.updated_at IS '修改时间';

CREATE TABLE IF NOT EXISTS hg_sys_serve_log (
    id BIGSERIAL PRIMARY KEY,
    trace_id VARCHAR(50),
    level_format VARCHAR(32),
    content TEXT,
    stack JSONB,
    line VARCHAR(255) NOT NULL,
    trigger_ns BIGINT,
    status SMALLINT NOT NULL DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_serve_log IS '系统_服务日志';
COMMENT ON COLUMN hg_sys_serve_log.id IS '日志ID';
COMMENT ON COLUMN hg_sys_serve_log.trace_id IS '链路ID';
COMMENT ON COLUMN hg_sys_serve_log.level_format IS '日志级别';
COMMENT ON COLUMN hg_sys_serve_log.content IS '日志内容';
COMMENT ON COLUMN hg_sys_serve_log.stack IS '打印堆栈';
COMMENT ON COLUMN hg_sys_serve_log.line IS '调用行';
COMMENT ON COLUMN hg_sys_serve_log.trigger_ns IS '触发时间(ns)';
COMMENT ON COLUMN hg_sys_serve_log.status IS '状态';
COMMENT ON COLUMN hg_sys_serve_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_serve_log.updated_at IS '修改时间';

CREATE TABLE IF NOT EXISTS hg_sys_sms_log (
    id BIGSERIAL PRIMARY KEY,
    event VARCHAR(64) NOT NULL,
    mobile VARCHAR(20) NOT NULL DEFAULT '',
    code VARCHAR(256) DEFAULT '',
    times BIGINT NOT NULL,
    ip VARCHAR(128),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

COMMENT ON TABLE hg_sys_sms_log IS '系统_短信发送记录';
COMMENT ON COLUMN hg_sys_sms_log.id IS '主键';
COMMENT ON COLUMN hg_sys_sms_log.event IS '事件';
COMMENT ON COLUMN hg_sys_sms_log.mobile IS '手机号';
COMMENT ON COLUMN hg_sys_sms_log.code IS '验证码或短信内容';
COMMENT ON COLUMN hg_sys_sms_log.times IS '验证次数';
COMMENT ON COLUMN hg_sys_sms_log.ip IS 'ip地址';
COMMENT ON COLUMN hg_sys_sms_log.status IS '状态(1未验证,2已验证)';
COMMENT ON COLUMN hg_sys_sms_log.created_at IS '创建时间';
COMMENT ON COLUMN hg_sys_sms_log.updated_at IS '更新时间';

-- 设置自增序列起始值
ALTER SEQUENCE hg_sys_sms_log_id_seq RESTART WITH 2;

CREATE TABLE IF NOT EXISTS hg_test_category (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    short_name VARCHAR(128),
    description VARCHAR(255),
    sort INTEGER NOT NULL,
    remark VARCHAR(255),
    status SMALLINT DEFAULT 1,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

COMMENT ON TABLE hg_test_category IS '测试分类';
COMMENT ON COLUMN hg_test_category.id IS '分类ID';
COMMENT ON COLUMN hg_test_category.name IS '分类名称';
COMMENT ON COLUMN hg_test_category.short_name IS '简称';
COMMENT ON COLUMN hg_test_category.description IS '描述';
COMMENT ON COLUMN hg_test_category.sort IS '排序';
COMMENT ON COLUMN hg_test_category.remark IS '备注';
COMMENT ON COLUMN hg_test_category.status IS '状态';
COMMENT ON COLUMN hg_test_category.created_at IS '创建时间';
COMMENT ON COLUMN hg_test_category.updated_at IS '修改时间';
COMMENT ON COLUMN hg_test_category.deleted_at IS '删除时间';

-- 设置自增序列起始值
ALTER SEQUENCE hg_test_category_id_seq RESTART WITH 5;


-- 插入 hg_addon_hgexample_tenant_order 表数据

-- 插入 hg_admin_cash 表数据

-- 插入 hg_admin_credits_log 表数据

-- 插入 hg_admin_dept 表数据

-- 插入 hg_admin_member 表数据
INSERT INTO hg_admin_member (
    id, dept_id, role_id, real_name, username, password_hash, salt, password_reset_token,
    integral, balance, avatar, sex, qq, email, mobile, birthday, city_id, address,
    pid, level, tree, invite_code, cash, last_active_at, remark, status,
    created_at, updated_at
) VALUES
      (1, 100, 1, '孟帅', 'admin', 'a7c588fffeb2c1d99b29879d7fe97c78', '6541561', '',
       88.00, 99289.78, 'https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8er9nfkchdopav.png',
       1, '133814250', '133814250@qq.com', '15303830571', '2016-04-16', 410172, '莲花街001号',
       0, 1, '', '111',
       '{"name": "孟帅", "account": "15303830571", "payeeCode": "https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8mqal5isvcb58g.jpg"}',
       '2024-08-27 19:02:49', NULL, 1,
       '2021-02-12 17:59:45', '2024-08-27 19:02:49');

--
-- 转存表中的数据 `hg_admin_member_post`
--


--
-- 转存表中的数据 `hg_admin_member_role`
--


-- 插入 hg_admin_menu 表数据

-- --------------------------------------------------------

-- 插入 hg_admin_notice 表数据

--
-- 转存表中的数据 `hg_admin_notice_read`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_admin_post`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_admin_role`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_admin_role_menu`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_addons_config`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_blacklist`
--


-- --------------------------------------------------------

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
    (128, 'upload', 'minio对外访问域名', 'string', 'uploadMinioDomain', '', '', 650, '', 1, 1, '2021-01-30 13:27:43', '2024-02-28 16:56:35');

-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_cron`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_cron_group`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_dict_data`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_dict_type`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_ems_log`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_gen_codes`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_gen_curd_demo`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_gen_tree_demo`
--


-- --------------------------------------------------------

--
-- 转存表中的数据 `hg_sys_provinces`
--






-- --------------------------------------------------------

--
-- 转存表中的数据 hg_sys_serve_license
--


-- --------------------------------------------------------

-- 插入 hg_sys_sms_log 表数据

-- 插入 hg_test_category 表数据

-- 更新序列值
SELECT setval('hg_test_category_id_seq', (SELECT MAX(id) FROM hg_test_category));

-- hg_addon_hgexample_tenant_order
CREATE INDEX ON hg_addon_hgexample_tenant_order (order_sn);
CREATE INDEX ON hg_addon_hgexample_tenant_order (user_id);
CREATE INDEX ON hg_addon_hgexample_tenant_order (merchant_id);
CREATE INDEX ON hg_addon_hgexample_tenant_order (tenant_id);

-- hg_admin_cash
CREATE INDEX ON hg_admin_cash (member_id);

-- hg_admin_credits_log
CREATE INDEX ON hg_admin_credits_log (member_id);

-- hg_admin_dept
CREATE INDEX ON hg_admin_dept (pid);

-- hg_admin_member
CREATE UNIQUE INDEX ON hg_admin_member (invite_code);
CREATE INDEX ON hg_admin_member (dept_id);
CREATE INDEX ON hg_admin_member (pid);

-- hg_admin_menu
CREATE UNIQUE INDEX ON hg_admin_menu (name);
CREATE INDEX ON hg_admin_menu (pid);
CREATE INDEX ON hg_admin_menu (status);
CREATE INDEX ON hg_admin_menu (type);

-- hg_admin_notice_read
CREATE UNIQUE INDEX ON hg_admin_notice_read (notice_id, member_id);

-- hg_admin_oauth
CREATE INDEX ON hg_admin_oauth (oauth_client, oauth_openid);
CREATE INDEX ON hg_admin_oauth (member_id);

-- hg_admin_order
CREATE INDEX ON hg_admin_order (order_sn);
CREATE INDEX ON hg_admin_order (member_id);

-- hg_pay_log
CREATE UNIQUE INDEX ON hg_pay_log (order_sn);
CREATE INDEX ON hg_pay_log (member_id);

-- hg_pay_refund
CREATE INDEX ON hg_pay_refund (order_sn);

-- hg_sys_addons_config
CREATE UNIQUE INDEX ON hg_sys_addons_config (addon_name, key);
CREATE INDEX ON hg_sys_addons_config (addon_name);
CREATE INDEX ON hg_sys_addons_config (addon_name, "group");

-- hg_sys_addons_install
CREATE UNIQUE INDEX ON hg_sys_addons_install (name);

-- hg_sys_attachment
CREATE INDEX ON hg_sys_attachment (md5);

-- hg_sys_blacklist
CREATE UNIQUE INDEX ON hg_sys_blacklist (ip);

-- hg_sys_config
CREATE INDEX ON hg_sys_config ("group");
CREATE INDEX ON hg_sys_config (key);

--
-- Indexes for table hg_sys_dict_data
--
CREATE INDEX dict_data_idx ON hg_sys_dict_data (type);

-- hg_sys_dict_type
CREATE UNIQUE INDEX dict_type_idx ON hg_sys_dict_type (type);

-- hg_sys_ems_log
CREATE INDEX ems_log_email_idx ON hg_sys_ems_log (email);

-- hg_sys_log
CREATE INDEX log_error_code_idx ON hg_sys_log (error_code);
CREATE INDEX log_req_id_idx ON hg_sys_log (req_id);
CREATE INDEX log_member_id_idx ON hg_sys_log (member_id);

-- hg_sys_login_log
CREATE INDEX login_log_member_id_idx ON hg_sys_login_log (member_id);
CREATE INDEX login_log_req_id_idx ON hg_sys_login_log (req_id);

-- hg_sys_provinces
CREATE INDEX provinces_pid_idx ON hg_sys_provinces (pid);

-- hg_sys_serve_license
CREATE UNIQUE INDEX serve_license_appid_idx ON hg_sys_serve_license (appid);

-- hg_sys_serve_log
CREATE INDEX serve_log_level_format_idx ON hg_sys_serve_log (level_format);
CREATE INDEX serve_log_trace_id_idx ON hg_sys_serve_log (trace_id);

-- hg_sys_sms_log
CREATE INDEX sms_log_mobile_idx ON hg_sys_sms_log (mobile);

-- hg_test_category
-- hg_addon_hgexample_table
ALTER SEQUENCE hg_addon_hgexample_table_id_seq RESTART WITH 7;

-- hg_addon_hgexample_tenant_order
ALTER SEQUENCE hg_addon_hgexample_tenant_order_id_seq RESTART WITH 2;

-- hg_admin_cash
ALTER SEQUENCE hg_admin_cash_id_seq RESTART WITH 2;

-- hg_admin_credits_log
ALTER SEQUENCE hg_admin_credits_log_id_seq RESTART WITH 8;

-- hg_admin_dept
ALTER SEQUENCE hg_admin_dept_id_seq RESTART WITH 113;

-- hg_admin_member
ALTER SEQUENCE hg_admin_member_id_seq RESTART WITH 14;

-- hg_admin_menu
ALTER SEQUENCE hg_admin_menu_id_seq RESTART WITH 2431;

-- hg_admin_notice
ALTER SEQUENCE hg_admin_notice_id_seq RESTART WITH 33;

-- hg_admin_notice_read
ALTER SEQUENCE hg_admin_notice_read_id_seq RESTART WITH 9;

-- hg_admin_oauth
SELECT setval('hg_admin_oauth_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM hg_admin_oauth));

-- hg_admin_order
ALTER SEQUENCE hg_admin_order_id_seq RESTART WITH 2;

-- hg_admin_post
ALTER SEQUENCE hg_admin_post_id_seq RESTART WITH 7;

-- hg_admin_role
ALTER SEQUENCE hg_admin_role_id_seq RESTART WITH 211;

-- hg_admin_role_casbin
SELECT setval('hg_admin_role_casbin_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM hg_admin_role_casbin));

-- hg_pay_log
ALTER SEQUENCE hg_pay_log_id_seq RESTART WITH 2;

-- hg_pay_refund
SELECT setval('hg_pay_refund_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM hg_pay_refund));

-- hg_sys_addons_config
ALTER SEQUENCE hg_sys_addons_config_id_seq RESTART WITH 2;

-- hg_sys_addons_install
ALTER SEQUENCE hg_sys_addons_install_id_seq RESTART WITH 2;

-- hg_sys_attachment
ALTER SEQUENCE hg_sys_attachment_id_seq RESTART WITH 9;

-- hg_sys_blacklist
ALTER SEQUENCE hg_sys_blacklist_id_seq RESTART WITH 8;

-- hg_sys_config
ALTER SEQUENCE hg_sys_config_id_seq RESTART WITH 129;

-- hg_sys_cron
ALTER SEQUENCE hg_sys_cron_id_seq RESTART WITH 11;

-- hg_sys_cron_group
ALTER SEQUENCE hg_sys_cron_group_id_seq RESTART WITH 3;

-- hg_sys_dict_data
ALTER SEQUENCE hg_sys_dict_data_id_seq RESTART WITH 171;

-- hg_sys_dict_type
ALTER SEQUENCE hg_sys_dict_type_id_seq RESTART WITH 45;

-- hg_sys_ems_log
ALTER SEQUENCE hg_sys_ems_log_id_seq RESTART WITH 5;

-- hg_sys_gen_codes
ALTER SEQUENCE hg_sys_gen_codes_id_seq RESTART WITH 12;

-- hg_sys_gen_curd_demo
ALTER SEQUENCE hg_sys_gen_curd_demo_id_seq RESTART WITH 16;

-- hg_sys_gen_tree_demo
ALTER SEQUENCE hg_sys_gen_tree_demo_id_seq RESTART WITH 41;

-- hg_sys_log
SELECT setval('hg_sys_log_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM hg_sys_log));

-- hg_sys_login_log
SELECT setval('hg_sys_login_log_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM hg_sys_login_log));

-- hg_sys_serve_license
ALTER SEQUENCE hg_sys_serve_license_id_seq RESTART WITH 3;

-- hg_sys_serve_log
SELECT setval('hg_sys_serve_log_id_seq', (SELECT COALESCE(MAX(id), 0) + 1 FROM hg_sys_serve_log));

-- hg_sys_sms_log
ALTER SEQUENCE hg_sys_sms_log_id_seq RESTART WITH 2;

-- hg_test_category
ALTER SEQUENCE hg_test_category_id_seq RESTART WITH 5;

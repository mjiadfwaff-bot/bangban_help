-- SET NAMES utf8;
-- SET time_zone = '+00:00';
-- SET foreign_key_checks = 0;
-- SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

-- SET NAMES utf8mb4;






INSERT INTO `hg_admin_member` (`id`, `dept_id`, `role_id`, `real_name`, `username`, `password_hash`, `salt`, `password_reset_token`, `integral`, `balance`, `avatar`, `sex`, `qq`, `email`, `mobile`, `birthday`, `city_id`, `address`, `pid`, `level`, `tree`, `invite_code`, `cash`, `last_active_at`, `remark`, `status`, `created_at`, `updated_at`) VALUES
(1,	100,	1,	'孟帅',	'admin',	'a7c588fffeb2c1d99b29879d7fe97c78',	'6541561',	'',	89.00,	99290.78,	'https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8er9nfkchdopav.png',	1,	'133814250',	'133814250@qq.com',	'15303830571',	'2016-04-16',	410172,	'莲花街001号',	0,	1,	'',	'111',	'{\"name\": \"孟帅\", \"account\": \"15303830571\", \"payeeCode\": \"https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8mqal5isvcb58g.jpg\"}',	'2024-04-21 22:58:56',	NULL,	1,	'2021-02-12 17:59:45',	'2024-04-21 22:58:56');


















(29,	'upload',	'上传图片大小限制',	'int',	'uploadImageSize',	'1',	'2',	310,	'单位：MB',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(30,	'upload',	'上传图片类型限制',	'string',	'uploadImageType',	'jpg,jpeg,gif,npm,png,svg',	'jpg,jpeg,gif,npm,png,svg',	320,	'图片上传后缀类型限制',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(31,	'upload',	'上传文件大小限制',	'int',	'uploadFileSize',	'1000',	'10',	330,	'单位：MB',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(32,	'upload',	'上传文件类型限制',	'string',	'uploadFileType',	'doc,docx,pdf,zip,tar,xls,xlsx,rar,jpg,jpeg,gif,npm,png,svg',	'doc,docx,zip,xls,xlsx,rar,jpg,jpeg,gif,npm,png,svg',	340,	'文件上传后缀类型限制',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(33,	'upload',	'本地存储路径',	'string',	'uploadLocalPath',	'attachment/',	'attachment/',	350,	'对外访问的相对路径',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(34,	'upload',	'UCloud存储路径',	'string',	'uploadUCloudPath',	'hotgo/attachment/',	'hotgo/attachment/',	360,	'UC对象存储中的相对路径',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(35,	'upload',	'UCloud公钥',	'string',	'uploadUCloudPublicKey',	'',	'',	370,	'获取地址：https://console.ucloud.cn/ufile/token',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(36,	'upload',	'UCloud私钥',	'string',	'uploadUCloudPrivateKey',	'',	'',	380,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(37,	'upload',	'UCloud地域API',	'string',	'uploadUCloudBucketHost',	'api.ucloud.cn',	'api.ucloud.cn',	390,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(38,	'upload',	'UCloud存储桶名称',	'string',	'uploadUCloudBucketName',	'bufanyun',	'',	400,	'存储空间名称',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(39,	'upload',	'UCloud存储桶地域host',	'string',	'uploadUCloudFileHost',	'cn-bj.ufileos.com',	'cn-bj.ufileos.com',	410,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(40,	'upload',	'UCloud访问域名',	'string',	'uploadUCloudEndpoint',	'https://gmycos.facms.cn',	'',	420,	'格式，http://abc.com 或  https://abc.com，不可为空',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(41,	'geo',	'高德Web服务key',	'string',	'geoAmapWebKey',	'',	'',	500,	'申请地址：https://console.amap.com/dev/key/app',	1,	1,	'2021-01-30 13:27:43',	'2022-12-07 15:48:43'),
(42,	'sms',	'短信驱动,aliyun：阿里云;tencent：腾讯云',	'string',	'smsDrive',	'tencent',	'',	600,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(43,	'sms',	'阿里云AccessKeyID',	'string',	'smsAliYunAccessKeyID',	'',	'',	610,	'应用key和密钥你可以通过 https://ram.console.aliyun.com/manage/ak 获取',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(44,	'sms',	'阿里云AccessKeySecret',	'string',	'smsAliYunAccessKeySecret',	'',	'',	620,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(45,	'sms',	'阿里云短信签名',	'string',	'smsAliYunSign',	'',	'',	630,	'申请地址：https://dysms.console.aliyun.com/domestic/text/sign',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(46,	'sms',	'阿里云短信模板',	'string',	'smsAliYunTemplate',	'[{\"key\":\"login\",\"value\":\"SMS_198921686\"},{\"key\":\"register\",\"value\":\"SMS_198921686\"},{\"key\":\"code\",\"value\":\"SMS_198921686\"},{\"key\":\"resetPwd\",\"value\":\"SMS_198921686\"},{\"key\":\"bind\",\"value\":\"SMS_198921686\"},{\"key\":\"cash\",\"value\":\"SMS_198921686\"}]',	'',	640,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(47,	'sms',	'最小发送间隔',	'int',	'smsMinInterval',	'60',	'',	600,	'同号码',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(48,	'sms',	'IP最大发送次数',	'int',	'smsMaxIpLimit',	'10',	'',	610,	'同IP每天最大允许发送次数',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(49,	'sms',	'验证码有效期',	'int',	'smsCodeExpire',	'600',	'',	610,	'单位：秒',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(50,	'smtp',	'邮件模板',	'string',	'smtpTemplate',	'[{\"key\":\"text\",\"value\":\"./resource/template/email/text.html\"},{\"key\":\"login\",\"value\":\"./resource/template/email/code.html\"},{\"key\":\"register\",\"value\":\"./resource/template/email/code.html\"},{\"key\":\"code\",\"value\":\"./resource/template/email/code.html\"},{\"key\":\"resetPwd\",\"value\":\"./resource/template/email/resetPwd.html\"},{\"key\":\"bind\",\"value\":\"./resource/template/email/code.html\"},{\"key\":\"cash\",\"value\":\"./resource/template/email/code.html\"}]',	'',	190,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-02-04 16:59:13'),
(51,	'smtp',	'最小发送间隔',	'int',	'smtpMinInterval',	'60',	'',	150,	'同地址',	1,	1,	'2021-01-30 13:27:43',	'2023-02-04 16:59:13'),
(52,	'smtp',	'IP最大发送次数',	'int',	'smtpMaxIpLimit',	'10',	'',	160,	'同IP每天最大允许发送次数',	1,	1,	'2021-01-30 13:27:43',	'2023-02-04 16:59:13'),
(53,	'smtp',	'验证码有效期',	'int',	'smtpCodeExpire',	'600',	'',	170,	'单位：秒',	1,	1,	'2021-01-30 13:27:43',	'2023-02-04 16:59:13'),
(54,	'basic',	'网站域名',	'string',	'basicDomain',	'https://hotgo.facms.cn',	'https://hotgo.facms.cn',	45,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-04-21 22:58:30'),
(55,	'basic',	'websocket地址',	'string',	'basicWsAddr',	'wss://hotgo.facms.cn/socket',	'wss://hotgo.facms.cn/socket',	48,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-04-21 22:58:30'),
(56,	'upload',	'COS存储路径',	'string',	'uploadCosPath',	'hotgo/attachment/',	'hotgo/attachment/',	450,	'COS对象存储中的相对路径',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(57,	'upload',	'COS秘钥ID',	'string',	'uploadCosSecretId',	'',	'',	460,	'子账号密钥获取可参考 https://cloud.tencent.com/document/product/598/37140',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(58,	'upload',	'COS秘钥',	'string',	'uploadCosSecretKey',	'',	'',	470,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(59,	'upload',	'COS访问域名',	'string',	'uploadCosBucketURL',	'',	'https://xxx-1253625515.cos.ap-beijing.myqcloud.com',	480,	'控制台查看地址：https://console.cloud.tencent.com/cos/bucket',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(60,	'upload',	'OSS存储路径',	'string',	'uploadOssPath',	'hotgo/attachment/',	'hotgo/attachment/',	500,	'OSS对象存储中的相对路径',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(61,	'upload',	'OSS秘钥ID',	'string',	'uploadOssSecretId',	'',	'',	510,	'阿里云账号AccessKey拥有所有API的访问权限，风险很高。强烈建议您创建并使用RAM用户进行API访问或日常运维，请登录RAM控制台创建RAM用户。',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(62,	'upload',	'OSS秘钥',	'string',	'uploadOssSecretKey',	'',	'',	520,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(63,	'upload',	'Bucket 域名',	'string',	'uploadOssBucketURL',	'http://bufanyunoss.oss-cn-qingdao.aliyuncs.com',	'https://xxx.oss-cn-qingdao.aliyuncs.com',	530,	'Bucket 域名',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(64,	'upload',	'OSSEndpoint',	'string',	'uploadOssEndpoint',	'http://oss-cn-qingdao.aliyuncs.com',	'https://oss-cn-qingdao.aliyuncs.com',	540,	'Endpoint（地域节点）',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(65,	'upload',	'OSS存储空间名称',	'string',	'uploadOssBucket',	'',	'',	550,	'存储空间名称，例如examplebucket',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(66,	'upload',	'七牛云AccessKey',	'string',	'uploadQiNiuAccessKey',	'',	'',	600,	'创建地址：https://portal.qiniu.com/user/key',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(67,	'upload',	'七牛云SecretKey',	'string',	'uploadQiNiuSecretKey',	'',	'',	610,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(68,	'upload',	'七牛云储存路径',	'string',	'uploadQiNiuPath',	'hotgo/attachment/',	'hotgo/attachment/',	620,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(69,	'upload',	'七牛云存储空间名称',	'string',	'uploadQiNiuBucket',	'',	'bufanyun',	630,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(70,	'upload',	'七牛云访问域名',	'string',	'uploadQiNiuDomain',	'',	'',	640,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(78,	'sms',	'腾讯云SecretId',	'string',	'smsTencentSecretId',	'',	'',	650,	'获取地址：https://console.cloud.tencent.com/cam/capi',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(79,	'sms',	'腾讯云SecretKey',	'string',	'smsTencentSecretKey',	'',	'',	660,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(80,	'sms',	'腾讯云短信应用ID',	'string',	'smsTencentAppId',	'',	'',	670,	'查看地址：https://console.cloud.tencent.com/smsv2/app-manage',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(81,	'sms',	'腾讯云短信签名',	'string',	'smsTencentSign',	'',	'',	680,	'查看地址：https://console.cloud.tencent.com/smsv2/csms-sign',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(82,	'sms',	'腾讯云接入地域域名',	'string',	'smsTencentEndpoint',	'sms.tencentcloudapi.com',	'sms.tencentcloudapi.com',	690,	'默认就近地域接入域名为 sms.tencentcloudapi.com ，也支持指定地域域名访问，例如广州地域的域名为 sms.ap-guangzhou.tencentcloudapi.com',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(83,	'sms',	'腾讯云地域信息',	'string',	'smsTencentRegion',	'ap-guangzhou',	'ap-guangzhou',	695,	'支持的地域列表参考 https://cloud.tencent.com/document/api/382/52071#.E5.9C.B0.E5.9F.9F.E5.88.97.E8.A1.A8',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(84,	'sms',	'腾讯云短信模板',	'string',	'smsTencentTemplate',	'[{\"key\":\"login\",\"value\":\"1758990\"},{\"key\":\"register\",\"value\":\"1758990\"},{\"key\":\"code\",\"value\":\"1758990\"},{\"key\":\"resetPwd\",\"value\":\"1758990\"},{\"key\":\"bind\",\"value\":\"1758990\"},{\"key\":\"cash\",\"value\":\"1758990\"}]',	'',	698,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-04-10 13:55:32'),
(85,	'pay',	'Debug开关',	'bool',	'payDebug',	'1',	'true',	800,	'输出请求日志',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(86,	'pay',	'支付宝应用ID',	'string',	'payAliPayAppId',	'',	'',	810,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(87,	'pay',	'支付宝PrivateKey',	'string',	'payAliPayPrivateKey',	'storage/cert/pay/alipay/alipayPrivateKey',	'',	820,	'应用私钥，支持PKCS1和PKCS8',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(88,	'pay',	'支付宝AppCertPublicKey',	'string',	'payAliPayAppCertPublicKey',	'storage/cert/pay/alipay/appCertPublicKey.crt',	'',	830,	'appCertPublicKey.crt证书内容',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(89,	'pay',	'支付宝RootCert',	'string',	'payAliPayRootCert',	'storage/cert/pay/alipay/alipayRootCert.crt',	'',	840,	'alipayRootCert.crt证书内容',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(90,	'pay',	'支付宝PublicKeyRSA2',	'string',	'payAliPayCertPublicKeyRSA2',	'storage/cert/pay/alipay/alipayCertPublicKey_RSA2.crt',	'',	850,	'alipayCertPublicKey_RSA2.crt证书内容',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(91,	'pay',	'微信支付应用ID',	'string',	'payWxPayAppId',	'',	'',	860,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(92,	'pay',	'微信支付商户ID',	'string',	'payWxPayMchId',	'',	'',	870,	'商户ID 或者服务商模式的 sp_mchid',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(93,	'pay',	'微信支付证书序列号',	'string',	'payWxPaySerialNo',	'',	'',	880,	'商户证书的证书序列号',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(94,	'pay',	'微信支付APIv3Key',	'string',	'payWxPayAPIv3Key',	'',	'',	890,	'商户平台获取',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(95,	'pay',	'微信支付私钥',	'string',	'payWxPayPrivateKey',	'',	'',	900,	'apiclient_key.pem 读取后的内容',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(96,	'pay',	'QQ支付应用ID',	'string',	'payQQPayAppId',	'',	'',	910,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(97,	'pay',	'QQ支付商户ID',	'string',	'payQQPayMchId',	'',	'',	920,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(98,	'pay',	'QQ支付ApiKey',	'string',	'payQQPayApiKey',	'',	'',	930,	'API秘钥值',	1,	1,	'2021-01-30 13:27:43',	'2023-08-05 14:00:56'),
(99,	'cash',	'提现开关',	'int',	'cashSwitch',	'1',	'1',	200,	'',	1,	1,	'2021-09-29 23:51:21',	'2022-12-21 21:58:52'),
(100,	'cash',	'提现最低手续费（元）',	'int',	'cashMinFee',	'3',	'3',	210,	'',	1,	1,	'2021-09-29 23:51:21',	'2022-12-21 21:58:52'),
(101,	'cash',	'提现最低手续费比率',	'string',	'cashMinFeeRatio',	'0.03',	'0.03',	220,	'',	1,	1,	'2021-01-30 13:27:43',	'2022-12-21 21:58:52'),
(102,	'cash',	'提现最低金额',	'int',	'cashMinMoney',	'100',	'',	230,	'',	1,	1,	'2021-01-30 13:27:43',	'2022-12-21 21:58:52'),
(103,	'cash',	'提现提示信息',	'string',	'cashTips',	'<p>温馨提示：请保证支付宝信息姓名、账号、收款码信息一致且无误，否则导致不到账后果自负。</p>\n\n <p>提现条件：满100元后可申请提现。</p>\n <p>提现手续费：固定3元/次，提现金额超过100元按3%收取，封顶135元/次。</p>',	'',	240,	'',	1,	1,	'2021-01-30 13:27:43',	'2022-12-21 21:58:52'),
(104,	'wechat',	'公众号AppId',	'string',	'officialAccountAppId',	'',	'',	1000,	'请填写微信公众平台后台的AppId',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(105,	'wechat',	'公众号AppSecret',	'string',	'officialAccountAppSecret',	'',	'',	1010,	'请填写微信公众平台后台的AppSecret',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(106,	'wechat',	'公众号token',	'string',	'officialAccountToken',	'',	'',	1020,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(107,	'wechat',	'公众号EncodingAESKey',	'string',	'officialAccountEncodingAESKey',	'',	'',	1030,	'与公众平台接入设置值一致，必须为英文或者数字，长度为43个字符. 请妥善保管,EncodingAESKey 泄露将可能被窃取或篡改平台的操作数据',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(108,	'wechat',	'开放平台AppId',	'string',	'openPlatformAppId',	'',	'',	1040,	'请填写微信开放平台平台后台的AppId',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(109,	'wechat',	'开放平台AppSecret',	'string',	'openPlatformAppSecret',	'',	'',	1050,	'请填写微信开放平台平台后台的AppSecret',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(110,	'wechat',	'开放平台EncodingAESKey',	'string',	'openPlatformEncodingAESKey',	'',	'',	1060,	'与开放平台接入设置值一致，必须为英文或者数字，长度为43个字符. 请妥善保管,EncodingAESKey 泄露将可能被窃取或篡改平台的操作数据',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(111,	'wechat',	'开放平台token',	'string',	'openPlatformToken',	'',	'',	1070,	'',	1,	1,	'2021-01-30 13:27:43',	'2023-07-26 16:06:53'),
(112,	'login',	'注册开关',	'int',	'loginRegisterSwitch',	'1',	'1',	1100,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(113,	'login',	'验证码开关',	'int',	'loginCaptchaSwitch',	'1',	'1',	1110,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(114,	'login',	'用户协议',	'string',	'loginProtocol',	'<p><span style=\"color: rgb(31, 34, 37);\">用户协议..</span></p>',	'',	1120,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(115,	'login',	'隐私权政策',	'string',	'loginPolicy',	'<p><span style=\"color: rgb(31, 34, 37);\">隐私权政策..</span></p>',	'',	1130,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(116,	'login',	'默认注册角色',	'int64',	'loginRoleId',	'202',	'',	1140,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(117,	'login',	'默认注册部门',	'int64',	'loginDeptId',	'109',	'',	1150,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(118,	'login',	'默认注册岗位',	'[]int64',	'loginPostIds',	'[6]',	'',	1160,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(119,	'login',	'默认注册头像',	'string',	'loginAvatar',	'https://gmycos.facms.cn/hotgo/attachment/2023-02-09/cqdq8er9nfkchdopav.png',	'',	1170,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(120,	'login',	'强制邀请',	'int',	'loginForceInvite',	'2',	'1',	1190,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(121,	'login',	'自动获取openId',	'int',	'loginAutoOpenId',	'2',	'1',	1195,	'',	1,	1,	'2021-09-29 23:51:21',	'2023-08-04 17:03:36'),
(122,	'upload',	'minio AccessKey',	'string',	'uploadMinioAccessKey',	'',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(123,	'upload',	'minio SecretKey',	'string',	'uploadMinioSecretKey',	'',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(124,	'upload',	'minio地域节点',	'string',	'uploadMinioEndpoint',	'',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(125,	'upload',	'minio是否启用SSL',	'int',	'uploadMinioUseSSL',	'1',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(126,	'upload',	'minio存储路径',	'string',	'uploadMinioPath',	'hotgo/attachment/',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(127,	'upload',	'minio桶名称',	'string',	'uploadMinioBucket',	'',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35'),
(128,	'upload',	'minio对外访问域名',	'string',	'uploadMinioDomain',	'',	'',	650,	'',	1,	1,	'2021-01-30 13:27:43',	'2024-02-28 16:56:35');
















-- 2024-05-13 02:00:07

import { h } from 'vue';
import { NTag, NTooltip } from 'naive-ui';

export interface BotRow {
  key: string;
  token: string;
  displayName: string;
  username: string;
  webhookSecret: string;
  webhookPath: string;
  runtimeStatus: string;
  runtimeMessage: string;
  starting?: boolean;
  enabled: boolean;
  autoPull: boolean;
  autoForward: boolean;
  reviewEnabled: boolean;
  role: string;
  plugins?: Record<string, any>;
  createdAt?: string;
  updatedAt?: string;
}

export function newBotRow(row?: Partial<BotRow>): BotRow {
  return {
    key: '',
    token: '',
    displayName: '',
    username: '',
    webhookSecret: '',
    webhookPath: '',
    runtimeStatus: 'pending',
    runtimeMessage: '',
    enabled: true,
    autoPull: false,
    autoForward: false,
    reviewEnabled: true,
    role: 'user',
    ...row,
  };
}

export const rules = {
  key: {
    required: true,
    trigger: ['blur', 'input'],
    message: '请输入机器人标识',
  },
  token: {
    required: true,
    trigger: ['blur', 'input'],
    message: '请输入 Bot Token',
  },
  role: {
    required: true,
    trigger: ['blur', 'change'],
    message: '请选择机器人权限',
  },
};

export const roleOptions = [
  { label: '用户机器人', value: 'user' },
  { label: '资金主机器人', value: 'finance' },
];

export const columns = [
  {
    title: '机器人标识',
    key: 'key',
    width: 150,
  },
  {
    title: '机器人名称',
    key: 'displayName',
    width: 180,
  },
  {
    title: '用户名',
    key: 'username',
    width: 180,
  },
  {
    title: '权限',
    key: 'role',
    width: 120,
    render(row: BotRow) {
      const type = row.role === 'finance' ? 'warning' : 'success';
      const label = row.role === 'finance' ? '资金主机器人' : '用户机器人';
      return h(NTag, { type, bordered: false }, { default: () => label });
    },
  },
  {
    title: '状态',
    key: 'runtimeStatus',
    width: 180,
    render(row: BotRow) {
      if (row.starting) {
        return h(NTag, { type: 'info', bordered: false }, { default: () => '启动中' });
      }
      if (!row.enabled) {
        return h(NTag, { bordered: false }, { default: () => '已关闭' });
      }
      const status = row.runtimeStatus || (row.enabled ? 'pending' : 'disabled');
      const typeMap = {
        running: 'success',
        error: 'error',
        pending: 'default',
        disabled: 'default',
      };
      const labelMap = {
        running: '运行中',
        error: '异常',
        pending: '未启动',
        disabled: '已关闭',
      };
      const tag = h(
        NTag,
        { type: typeMap[status] || 'default', bordered: false },
        { default: () => labelMap[status] || status }
      );
      if (status !== 'error' || !row.runtimeMessage) {
        return tag;
      }
      return h(NTooltip, null, {
        trigger: () => tag,
        default: () => row.runtimeMessage,
      });
    },
  },
  {
    title: '更新时间',
    key: 'updatedAt',
    width: 180,
  },
];

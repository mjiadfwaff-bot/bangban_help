<template>
  <n-form :label-width="110" :model="formValue">
    <n-form-item label="插件名称">
      <n-input v-model:value="formValue.name" />
    </n-form-item>
    <n-form-item label="插件副标题">
      <n-input v-model:value="formValue.subtitle" />
    </n-form-item>
    <n-form-item label="插件分类">
      <n-input v-model:value="formValue.category" />
    </n-form-item>
    <n-form-item label="插件简介">
      <n-input v-model:value="formValue.description" type="textarea" />
    </n-form-item>
    <n-form-item v-if="hasCommandConfig" label="命令配置">
      <n-space vertical class="full-width">
        <n-input v-model:value="formValue.command" placeholder="主命令，例如 /拉取" />
        <n-dynamic-input
          v-model:value="formValue.commands"
          :min="1"
          placeholder="输入命令，例如 /绑定"
        />
      </n-space>
    </n-form-item>
    <n-form-item label="开关">
      <n-space>
        <n-checkbox v-model:checked="formValue.enabled">全局启用</n-checkbox>
        <n-checkbox v-model:checked="formValue.userEnabled">允许用户启用</n-checkbox>
        <n-checkbox v-model:checked="formValue.paid">增值插件</n-checkbox>
      </n-space>
    </n-form-item>
    <n-form-item label="价格">
      <n-input v-model:value="formValue.price" placeholder="免费插件填 0" />
    </n-form-item>
    <n-form-item label="排序">
      <n-input-number v-model:value="formValue.sort" :show-button="false" />
    </n-form-item>
    <template v-if="formValue.key === 'welcome'">
      <n-form-item label="欢迎语内容">
        <TelegramRichEditor v-model:value="welcomeValue.text" />
      </n-form-item>
      <n-form-item label="挂载能力">
        <n-select
          v-model:value="welcomeValue.mountedPlugins"
          multiple
          clearable
          :options="mountPluginOptions"
          placeholder="选择 /start 后需要挂载的插件能力"
        />
      </n-form-item>
    </template>
    <RichButtonEditor
      v-else-if="formValue.key === 'menu'"
      v-model:value="menuValue"
    />
    <template v-else-if="formValue.key === 'collector'">
      <n-form-item label="默认模式">
        <n-select
          v-model:value="collectorValue.defaultMode"
          :options="[
            { label: '快速采集：直接发布到当前会话', value: 'quick' },
            { label: '审核发布：先进入审核群', value: 'review' },
          ]"
        />
      </n-form-item>
      <n-form-item label="菜单显示">
        <n-switch v-model:value="collectorValue.menuVisible" />
      </n-form-item>
      <n-form-item label="公开入口">
        <n-space>
          <n-checkbox v-model:checked="collectorValue.showVerifyLink">显示验证视频入口</n-checkbox>
          <n-checkbox v-model:checked="collectorValue.showLocationLink">显示位置入口</n-checkbox>
        </n-space>
      </n-form-item>
      <n-form-item label="页脚">
        <n-input
          v-model:value="collectorValue.footer"
          type="textarea"
          :autosize="{ minRows: 3, maxRows: 8 }"
          placeholder="每条采集笔记底部展示的文案，支持 Telegram HTML"
        />
      </n-form-item>
      <n-form-item label="推送模板">
        <n-input
          v-model:value="collectorValue.captionTemplate"
          type="textarea"
          :autosize="{ minRows: 6, maxRows: 12 }"
          placeholder="{title} {text} {code} {verify_link} {location_link} {footer}"
        />
      </n-form-item>
      <n-form-item label="绑定提示">
        <n-input
          v-model:value="collectorValue.bindHelpText"
          type="textarea"
          :autosize="{ minRows: 3, maxRows: 6 }"
        />
      </n-form-item>
      <n-form-item label="入口文案">
        <n-space vertical class="full-width">
          <n-input v-model:value="collectorValue.verifyLinkText" placeholder="验证视频入口文案" />
          <n-input v-model:value="collectorValue.locationLinkText" placeholder="位置入口文案" />
        </n-space>
      </n-form-item>
    </template>
    <n-form-item v-else label="配置 JSON">
      <n-input
        v-model:value="settingsText"
        type="textarea"
        :autosize="{ minRows: 5, maxRows: 10 }"
        placeholder='{"key":"value"}'
      />
    </n-form-item>
    <n-space justify="end">
      <n-button type="primary" @click="submit">保存</n-button>
    </n-space>
  </n-form>
</template>

<script lang="ts" setup>
  import { computed, ref, watch } from 'vue';
  import { useMessage } from 'naive-ui';
  import RichButtonEditor from '../components/richButtonEditor.vue';
  import TelegramRichEditor from '../components/telegramRichEditor.vue';

  const props = defineProps({
    plugin: {
      type: Object,
      required: true,
    },
  });
  const emit = defineEmits(['submit']);
  const message = useMessage();
  const formValue = ref<any>({});
  const settingsText = ref('{}');
  const welcomeValue = ref<any>({});
  const menuValue = ref<any>({});
  const collectorValue = ref<any>({});
  const hasCommandConfig = computed(() => {
    return ['collector', 'signin', 'member', 'review', 'welcome', 'menu'].includes(formValue.value.key);
  });
  const mountPluginOptions = computed(() => {
    const key = formValue.value.key;
    return Object.values((formValue.value as any).allPlugins || {})
      .filter((item: any) => item && item.key !== key)
      .map((item: any) => ({
        label: `${item.name || item.key}${item.subtitle ? ` - ${item.subtitle}` : ''}`,
        value: item.key,
      }));
  });

  watch(
    () => props.plugin,
    (value) => {
      formValue.value = { ...(value || {}) };
      settingsText.value = JSON.stringify(formValue.value.settings || {}, null, 2);
      formValue.value.allPlugins = value?.allPlugins || {};
      welcomeValue.value = {
        text: formValue.value.settings?.welcomeText || '',
        mountedPlugins: normalizeMountedPlugins(formValue.value.settings),
      };
      formValue.value.command = formValue.value.settings?.command || '';
      formValue.value.commands = normalizeCommands(formValue.value.settings?.commands, formValue.value.settings?.command);
      menuValue.value = {
        menuVisible: formValue.value.settings?.menuVisible !== false,
        buttons: formValue.value.settings?.buttons || [],
        showPluginCommands: formValue.value.settings?.showPluginCommands !== false,
        command: formValue.value.settings?.command || '',
        commands: normalizeCommands(formValue.value.settings?.commands, formValue.value.settings?.command),
      };
      collectorValue.value = {
        defaultMode: formValue.value.settings?.defaultMode || 'quick',
        menuVisible: formValue.value.settings?.menuVisible !== false,
        command: formValue.value.settings?.command || '/拉取',
        commands: normalizeCommands(formValue.value.settings?.commands, formValue.value.settings?.command),
        showVerifyLink: formValue.value.settings?.showVerifyLink !== false,
        showLocationLink: formValue.value.settings?.showLocationLink !== false,
        footer: formValue.value.settings?.footer || '',
        captionTemplate: formValue.value.settings?.captionTemplate || '',
        bindHelpText: formValue.value.settings?.bindHelpText || '',
        verifyLinkText: formValue.value.settings?.verifyLinkText || '📒 点击查看验证视频',
        locationLinkText: formValue.value.settings?.locationLinkText || '📍 点击查看位置',
      };
    },
    { immediate: true }
  );

  function submit() {
    if (formValue.value.key === 'welcome') {
      formValue.value.settings = {
        ...(formValue.value.settings || {}),
        welcomeText: welcomeValue.value.text || '',
        mountedPlugins: welcomeValue.value.mountedPlugins || [],
        mountMenu: (welcomeValue.value.mountedPlugins || []).includes('menu'),
      };
    } else if (formValue.value.key === 'menu') {
      formValue.value.settings = {
        ...(formValue.value.settings || {}),
        menuVisible: menuValue.value.menuVisible !== false,
        buttons: menuValue.value.buttons || [],
        showPluginCommands: menuValue.value.showPluginCommands !== false,
        command: menuValue.value.command || '',
        commands: normalizeCommands(menuValue.value.commands, menuValue.value.command),
      };
    } else if (formValue.value.key === 'collector') {
      formValue.value.settings = {
        ...(formValue.value.settings || {}),
        defaultMode: collectorValue.value.defaultMode || 'quick',
        menuVisible: collectorValue.value.menuVisible !== false,
        command: collectorValue.value.command || '/拉取',
        commands: normalizeCommands(collectorValue.value.commands, collectorValue.value.command),
        showVerifyLink: collectorValue.value.showVerifyLink !== false,
        showLocationLink: collectorValue.value.showLocationLink !== false,
        footer: collectorValue.value.footer || '',
        captionTemplate: collectorValue.value.captionTemplate || '',
        bindHelpText: collectorValue.value.bindHelpText || '',
        verifyLinkText: collectorValue.value.verifyLinkText || '',
        locationLinkText: collectorValue.value.locationLinkText || '',
      };
    } else {
      try {
        const parsed = JSON.parse(settingsText.value || '{}');
        if (hasCommandConfig.value) {
          parsed.command = formValue.value.command || parsed.command || '';
          parsed.commands = normalizeCommands(formValue.value.commands, parsed.command);
        }
        formValue.value.settings = parsed;
      } catch (e) {
        message.error('配置 JSON 格式不正确');
        return;
      }
    }
    emit('submit', { ...formValue.value });
  }

  function normalizeMountedPlugins(settings) {
    const mounted = Array.isArray(settings?.mountedPlugins) ? settings.mountedPlugins : [];
    if (mounted.length > 0) {
      return mounted;
    }
    if (settings?.mountMenu !== false) {
      return ['menu'];
    }
    return [];
  }

  function normalizeCommands(commands, fallback) {
    const list = Array.isArray(commands) ? commands : [];
    const cleaned = list
      .map((item) => `${item || ''}`.trim())
      .filter((item) => item !== '');
    const primary = `${fallback || ''}`.trim();
    if (primary && !cleaned.includes(primary)) {
      cleaned.unshift(primary);
    }
    if (!cleaned.length) {
      cleaned.push('/拉取');
    }
    return cleaned;
  }

</script>

<style scoped>
  .full-width {
    width: 100%;
  }
</style>

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
      menuValue.value = {
        menuVisible: formValue.value.settings?.menuVisible !== false,
        buttons: formValue.value.settings?.buttons || [],
        showPluginCommands: formValue.value.settings?.showPluginCommands !== false,
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
      };
    } else {
      try {
        formValue.value.settings = JSON.parse(settingsText.value || '{}');
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
</script>

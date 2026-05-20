<template>
  <n-modal
    v-model:show="showModal"
    :mask-closable="false"
    :show-icon="false"
    preset="dialog"
    :title="title"
    :style="{ width: dialogWidth }"
  >
    <component :is="currentComponent" v-if="currentComponent" />
    <n-empty v-else description="该插件暂未提供后台配置页面"></n-empty>
  </n-modal>
</template>

<script lang="ts" setup>
  import { computed, defineAsyncComponent, ref, shallowRef } from 'vue';
  import { adaModalWidth } from '@/utils/hotgo';

  const showModal = ref(false);
  const title = ref('插件配置');
  const currentComponent = shallowRef<any>(null);
  const dialogWidth = computed(() => {
    return adaModalWidth(960);
  });

  const components = {
    lazysheep_tggo: defineAsyncComponent(
      () => import('@/views/addons/lazysheep_tggo/config/console.vue')
    ),
  };

  function openModal(record: Recordable) {
    title.value = `${record.label || record.name}配置`;
    currentComponent.value = components[record.name] || null;
    showModal.value = true;
  }

  defineExpose({
    openModal,
  });
</script>

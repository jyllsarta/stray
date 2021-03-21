<template lang="pug">
  .bg(:class="`bg_${fieldEffectStateId}`")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  props: {
    fieldEffectState: Object,
  },
  data: function () {
    return {
    };
  },
  store,
  mounted(){
  },
  computed: {
    fieldEffectStateId(){
      return this.fieldEffectState?.stateMaster?.id || "default";
    }
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.bg{
  position: absolute;
  width: 100%;
  height: 100%;

  &.bg_default{
    background-image: linear-gradient(to bottom, #2c344e 0%, transparent 15%);
  }
  &.bg_102{
    background-image: linear-gradient(to bottom, #1e3321 0%, transparent 15%);
  }
  &.bg_103{
    background-image: linear-gradient(to bottom, #4e3430 0%, transparent 15%);
  }
  &.bg_104{
    background-image: linear-gradient(to bottom, #454637 0%, transparent 15%);
  }
  &.bg_105{
    background-image: linear-gradient(to bottom, #445a55 0%, transparent 15%);
  }
  &.bg_106{
    background-image: linear-gradient(to bottom, #2b2350 0%, transparent 15%);
  }
  &.bg_107{
    background-image: linear-gradient(to bottom, #44365f 0%, transparent 15%);
  }
}
</style>

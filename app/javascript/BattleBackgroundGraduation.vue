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
    background-image: linear-gradient(to bottom, $gray3 0%, transparent 10%);
  }
  &.bg_102{
    background-image: linear-gradient(to bottom, #37463d 0%, transparent 15%);
  }
}
</style>

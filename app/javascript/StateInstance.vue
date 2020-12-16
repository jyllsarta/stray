<template lang="pug">
  .state
    img.icon(:src="`/images/icons/states/${stateInstance.stateMaster.icon}`")
    .count
      | {{stateInstance.showParameter()}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Vue from 'vue'

export default {
  props: {
    stateInstance: Object,
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.state {
  position: relative;
  width: 24px;
  height: 24px;
  margin-right: $space;
  .icon{
  }
  .count{
    position: absolute;
    background-color: $background;
    bottom: 0;
    right: 0;
  }
}
</style>

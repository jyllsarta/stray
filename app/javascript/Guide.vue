<template lang="pug">
  .guide
    .guide
     | {{$store.state.ui.guide}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.guide{
  height: $guide-height;
  width: $window-width - $space * 2;
  border-bottom: 1px solid $gray3;
  border-radius: $radius;
  margin-left: $space;
  margin-right: $space;
  display: flex;
  align-items: center;
  .guide{
    padding-left: $space;
  }
}
</style>

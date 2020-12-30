<template lang="pug">
  .background_fields
    img.background_field(src="/images/battle/background.png" :class="turnInProgress ? 'zoomed' : 'normal'")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  props: {
    turnInProgress: Boolean
  },
  data: function () {
    return {};
  },
  store,
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.background_fields{
  .background_field {
    position: absolute;
    width:70%;
    left: 15%;
    top: -50%;
    transform-origin: bottom;
  }
  .zoomed{
    transition: transform 0.6s;
    transform: scale(1.3);
  }
  .normal{
    transition: transform 0.6s;
    transform: scale(1);
  }
}
</style>

<template lang="pug">
  .background_fields(:class="turnInProgress ? 'zoomed' : 'normal'")
    .particles
    .floor

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
  position: relative;
  width: 100%;
  height: 100%;
  .floor {
    position: absolute;
    width: 70%;
    height: 70%;
    left: 15%;
    top: -25%;
    transform: perspective(1000px) rotateX(85deg);
    transform-origin: bottom center;
    background-image: linear-gradient(to bottom, $background 30%, $gray3 100%);
  }
}

.zoomed{
  transition: transform 0.6s;
  transform: scale(1.3);
}
.normal{
  transition: transform 0.6s;
  transform: scale(1);
}

</style>

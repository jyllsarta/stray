<template lang="pug">
  .foreground_fields(:class="turnInProgress ? 'zoomed' : 'normal'")
    BattleForeground

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import BattleForeground from "./BattleForeground.vue";

export default {
  components: {
    BattleForeground,
  },
  props: {
    turnInProgress: Boolean
  },
  data: function () {
    return {
    };
  },
  store,
  mounted(){
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.foreground_fields{
  position: relative;
  width: 100%;
  height: 100%;
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

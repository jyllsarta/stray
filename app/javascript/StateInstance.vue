<template lang="pug">
  .state(
    :class="stateInstance.isFlashing ? 'flashing' : ''",
    @mouseover="$store.commit('guide/updateGuide', stateInstance.stateMaster.description)"
    )
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
  watch: {
    "stateInstance.isFlashing": {
      handler: function (newVal, oldVal) {
        if(!newVal){
          return; // false への変化は光ってる状態からの戻りなので気にしない
        }
      }
    },
  }
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

.flashing{
  animation: anim 0.3s;
}

@keyframes anim {
  0% {
    opacity: 0.4;
    transform: scale(3);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}
</style>

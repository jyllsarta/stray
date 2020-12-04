<template lang="pug">
transition(name="anim")
  .turn_start.topic_medium
    .text
      | ターン開始！
</template>

<script lang="ts">
import Constants from "../packs/constants.ts";
import store from '../packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  mounted(){
    this.remove();
  },
  methods: {
    remove(){
      console.log("hide turn start fragment");
      this.$store.commit("battle/hideFragment", "turn_start");
    },
  },
}
</script>

<style lang="scss" scoped>
  .turn_start{
    position: absolute;
    top: calc(40% - 25px);
    left: calc(50% - 200px);
    height: 50px;
    width: 400px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .anim-leave-active {
    animation: anim 1.2s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: translateX(-10px);
    }
    30% {
      opacity: 1;
      transform: translateX(0px);
    }
    70% {
      opacity: 1;
      transform: translateX(0px);
    }
    100% {
      opacity: 0;
      transform: translateX(30px);
    }
  }
</style>

<template lang="pug">
transition(name="anim")
  .turn_start
    .text
      | ボス戦！
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
      this.$store.commit("battle/hideFragment", "boss_battle_start");
    },
  },
}
</script>

<style lang="scss" scoped>
  .turn_start{
    position: absolute;
    top: calc(40% - 15px);
    left: calc(50% - 200px);
    height: 30px;
    width: 400px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    border-top: 1px solid transparent;
    border-bottom: 1px solid transparent;
    background-color: #fff7fa20;
  }
  .anim-leave-active {
    animation: anim 0.8s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      border-top: 1px solid transparent;
      border-bottom: 1px solid transparent;
      transform:  scale(1.3);
    }
    30% {
      opacity: 1;
      transform:  scale(1);
    }
    50%{
      border-top: 1px solid #fff7fa;
      border-bottom: 1px solid #fff7fa;
    }
    70% {
      opacity: 1;
    }
    100% {
      opacity: 0;
      border-top: 1px solid #fff7fa00;
      border-bottom: 1px solid #fff7fa00;
    }
  }
</style>

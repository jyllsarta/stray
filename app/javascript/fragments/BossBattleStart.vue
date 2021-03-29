<template lang="pug">
transition(name="anim")
  .boss_battle_start
    .texts
      .ruby
        | Engaging Master Failies!!
      .main
        | 強敵出現!
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
  @import "../stylesheets/global_setting";

  .boss_battle_start{
    position: absolute;
    height: $window-height;
    width: $window-width;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #10101dde;
    .texts{
      height: 100px;
      width: 500px;
      border-top: 1px solid #fff7fa;
      border-bottom: 1px solid #fff7fa;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-direction: column;
      .ruby{
        font-size: $font-size-normal;
        line-height: 200%;
        text-align-last: justify;
        width: 200px;
      }
      .main{
        font-size: 40px;
        line-height: 100%;
        text-align-last: justify;
        width: 250px;
      }
    }
  }
  .anim-leave-active {
    animation: anim 2s linear;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: scale(3);
    }
    15% {
      opacity: 1;
      transform: scale(1);
    }
    80% {
      opacity: 1;
      transform: scale(0.98);
    }
    100% {
      opacity: 0;
    }
  }
</style>

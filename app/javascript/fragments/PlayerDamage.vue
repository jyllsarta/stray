<template lang="pug">
transition(name="anim")
  .damage
    .text(:class="damageClass")
      | {{Math.abs($store.state.battle.damageDiffs.player)}}
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
  computed: {
    damageClass(){
      return this.$store.state.battle.damageDiffs.player > 0 ? "heal" : "";
    },
  },
  methods: {
    remove(){
      this.$store.commit("battle/hideFragment", "player_damage");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .damage{
    position: absolute;
    top: calc(12% - 25px);
    left: calc(45% - 50px);
    height: 50px;
    width: 100px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: $font-size-large * 3;
    font-family: 'Forum', cursive;
    $color: rgb(143, 151, 255);
    text-shadow: 0px 0px 12px $color, 0px 0px 12px $color, 0px 0px 12px $color;
  }
  .heal{
    $color: rgb(115, 255, 0);
    text-shadow: 0px 0px 12px $color, 0px 0px 12px $color, 0px 0px 12px $color;
  }
  .anim-leave-active {
    animation: anim 0.8s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: scale(5);
    }
    20% {
      opacity: 1;
      transform: scale(1);
    }
    80% {
      opacity: 0.95;
      transform: scale(0.95);
    }
    100% {
      opacity: 0;
      transform: scale(0.8) translateY(-10px);
    }
  }
</style>

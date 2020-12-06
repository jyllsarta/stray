<template lang="pug">
transition(name="anim")
  .damage
    .text(:class="damageClass")
      | {{Math.abs($store.state.battle.damageDiffs.enemy)}}
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
      return this.$store.state.battle.damageDiffs.enemy > 0 ? "heal" : "";
    },
  },
  methods: {
    remove(){
      this.$store.commit("battle/hideFragment", "enemy_damage");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .damage{
    position: absolute;
    top: calc(12% - 25px);
    left: calc(55% - 50px);
    height: 50px;
    width: 100px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: $font-size-large * 1.5;
  }
  .heal{
    color: $dex;
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

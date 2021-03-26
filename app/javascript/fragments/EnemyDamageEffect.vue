<template lang="pug">
transition(name="anim")
  .damage
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
  },
  methods: {
    remove(){
      this.$store.commit("battle/hideFragment", "enemy_damage_effect");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .damage{
    position: absolute;
    top: calc(20% - 20px);
    left: calc(65% - 20px);
    height: 20px;
    width: 20px;
    opacity: 0;
    background-color: rgb(225, 228, 181);
    box-shadow: 0px 0px 10px 3px $rarity5, 0px 0px 15px 2px $rarity5 inset;
    border-radius: 10px;
  }
  .anim-leave-active {
    animation: anim 0.4s cubic-bezier(.07,.79,.68,.95);
    animation-delay: 0.15s;
  }
  @keyframes anim {
    0% {
      opacity: 0.8;
      transform: scale(0.5);
    }
    100% {
      opacity: 0;
      transform: translateX(10px) scale(5);
    }
  }
</style>

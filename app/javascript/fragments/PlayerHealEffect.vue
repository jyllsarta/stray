<template lang="pug">
transition(name="anim")
  .effect
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
      this.$store.commit("battle/hideFragment", "player_heal_effect");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .effect{
    position: absolute;
    top: calc(60% - 100px);
    left: calc(30% - 150px);
    height: 20px;
    width: 300px;
    background-color: rgba(181, 228, 218, 0.5);
    transform-origin: bottom;
    border-left: 3px solid rgb(181, 228, 218);
    border-right: 3px solid rgb(181, 228, 218);
  }
  .anim-leave-active {
    animation: anim 0.7s;
  }
  @keyframes anim {
    0% {
      opacity: 1;
      transform: scale(1, 1);
    }
    100% {
      opacity: 0;
      transform: scale(1, 10) translateY(-2px);
    }
  }
</style>

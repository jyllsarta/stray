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
      this.$store.commit("battle/hideFragment", "enemy_state_effect");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .effect{
    position: absolute;
    top: calc(60% - 100px);
    left: calc(65% - 150px);
    height: 20px;
    width: 300px;
    background-color: rgba(255, 238, 182, 0.5);
    transform-origin: bottom;
    border-left: 3px solid rgb(255, 254, 171);
    border-right: 3px solid rgb(255, 254, 171);
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

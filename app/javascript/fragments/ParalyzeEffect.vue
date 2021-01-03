<template lang="pug">
transition(name="anim")
  .effect
    .particles
      .particle.particle1
      .particle.particle2
      .particle.particle3
      .particle.particle4
      .particle.particle5
    .text
      | Stun!
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
      this.$store.commit("battle/hideFragment", "paralyze_effect");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .effect{
    position: absolute;
    top: calc(10% - 25px);
    left: calc(50% - 50px);
    height: 50px;
    width: 100px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: $font-size-large * 2;
    color: $white;
    font-style: italic;
    text-shadow: 0 0 10px $yellow,
                 0 0 20px $yellow,
                 0 0 30px $yellow,
                 0 0 40px $yellow,
                 0 0 50px $yellow,
                 0 0 50px $yellow,
                 0 0 60px $yellow,
                 0 0 60px $yellow;
  }
  .particles{
    .particle{
      position: absolute;
      transform: rotate(45deg);
      background-color: $yellow-opacity;
      animation: particle 1s;
      width: 8px;
      height: 8px;
    }
    .particle1{
      top: 10px;
      left: -25px;
    }
    .particle2{
      top:  0px;
      left: 10px;
    }
    .particle3{
      top: 38px;
      left: 40px;
    }
    .particle4{
      top: 40px;
      left: 80px;
    }
    .particle5{
      top: 20px;
      left: 105px;
    }
    @keyframes particle {
      0% {
        transform: rotate(45deg) scale(1);
      }
      100% {
        opacity: 0.7;
        transform: rotate(45deg) scale(1.5);
      }
    }
  }
  .anim-leave-active {
    animation: anim 1s;
  }
  @keyframes anim {
    0% {
      opacity: 0.5;
      transform: translateY(-20px) scale(2.5);
    }
    15% {
      opacity: 1;
      transform: translateY(0px) scale(1.05);
    }
    60% {
      opacity: 1;
      transform: translateY(0px);
    }
    100% {
      opacity: 0;
    }
  }
</style>

<template lang="pug">
  transition(name="frame")
    .frame
      .backgrounds
        .upper
        .downer
        .logo
          .red.rhombus
          .blue.rhombus
          .brown.rhombus
          .yellow.rhombus
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      show: true,
    };
  },
  store,
  mounted(){
  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.frame{
  position: absolute;
  top: 0;
  left: 0;
  width: $window-width;
  height: $window-height;

  .backgrounds{
    position: absolute;
    .upper{
      position: absolute;
      left: 0px;
      width: $window-width;
      height: $window-height / 2;
      background-color: $background;
      animation: left-out .25s cubic-bezier(.34,.76,.63,.97) 0s;
    }
    .downer{
      position: absolute;
      top: $window-height / 2;
      right: -$window-width;
      width: $window-width;
      height: $window-height / 2;
      background-color: $background;
      animation: right-out .25s cubic-bezier(.34,.76,.63,.97) 0s;
    }
  }
  .logo{
    position: absolute;
    left: $window-width/2 - 59px;
    top: $window-height/2 - 59px;
    transform: scaleY(1.4) rotate(45deg);
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    width: 120px;
    height: 120px;
    .rhombus{
      width: 58px;
      height: 58px;
      margin: 1px;
      animation: swing-in .3s cubic-bezier(1,.44,.81,1.51) 0s;
    }
    .red{
      background-color: #D7748E;
      animation-delay: 0.10s;
    }
    .brown{
      background-color: #50435B;
      animation-delay: 0.15s;
    }
    .yellow{
      background-color: #FCD99A;
      animation-delay: 0.20s;
    }
    .blue{
      background-color: #93baeb;
      animation-delay: 0.25s;
    }
    @keyframes swing-in {
      0% {
        opacity: 0.7;
        transform: scale(0.8);
      }
    }
    @keyframes left-out {
      0% {
        opacity: 0.2;
        width: 70%;
      }
    }
    @keyframes right-out {
      0% {
        opacity: 0.2;
        width: 70%;
      }
    }

  }
}

.frame {
  &-move {
    transition: transform 0.4s;
  }

  &-enter {
    &-active {
      opacity: 0;
      transform: translate3d(0, -10px, 0);
      transition: opacity 0.2s, transform 0.2s;
    }
    &-to {
      opacity: 1;
      transform: translate3d(0, 0, 0);
    }
  }

  &-leave {
    &-active {
      position: absolute;
      transition: opacity 0.4s, transform 0.4s;
    }
    &-to {
      opacity: 0;
      transform: translate3d(0, -10px, 0);
    }
  }
}


</style>

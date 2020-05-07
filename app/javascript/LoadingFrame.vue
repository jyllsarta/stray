<template lang="pug">
  transition(name="loading")
    .frame
      .text
        | ローディングなう
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
    window.addEventListener("load", (event) => {
      this.$store.commit("window/updateWindowShowState", {windowName: "loading_frame", state: false});
    });  },
  methods: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.frame {
  position: absolute;
  top: 0;
  left: 0;
  width: $window-width;
  height: $window-height;
  background-color: $background;
  display: flex;
  justify-content: center;
  align-items: center;
  .text{
    font-size: $font-size-large;
    color: $white;
    animation: loading_text 1s linear alternate infinite;
  }
  @keyframes loading_text {
    0% { opacity: 0}
    100% { opacity: 1}
  }
}

.loading {
  &-move {
    transition: transform 0.5s;
  }

  &-enter {
    &-active {
      opacity: 0;
      transform: translate3d(0, -30px, 0);
      transition: opacity 0.5s, transform 0.5s;
    }
    &-to {
      opacity: 1;
      transform: translate3d(0, 0, 0);
    }
  }

  &-leave {
    &-active {
      position: absolute;
      transition: opacity 0.5s, transform 0.5s;
    }
    &-to {
      opacity: 0;
      transform: translate3d(0, -30px, 0);
    }
  }
}


</style>

<template lang="pug">
  transition(name="loading")
    .frame
      .text
        | どこか別窓でゲームが開始されたみたいです。
        | ページを再読み込みすると、このウィンドウで遊び直せます。
      img.buee(src="/images/ui/tirol_dead.png")

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
    };
  },
  store,
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
  flex-direction: column;
  justify-content: center;
  align-items: center;
  .text{
    width: 70%;
    font-size: $font-size-large;
    white-space: pre;
    text-align: center;
    color: $white;
    animation: loading_text 0.3s linear alternate;
  }
  .buee{
    width: 300px;
  }
  @keyframes loading_text {
    0% {
      opacity: 0;
      transform: translateX(-30px);
    }
    100% {
      opacity: 1;
      transform: translateX(0px);
    }
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

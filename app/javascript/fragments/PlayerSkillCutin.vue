<template lang="pug">
transition(name="anim")
  .skill_cutin
    .base
      .head
        | ファイア
      .images
        .background
        .image
      .descri
        | 敵に5点ダメージ。
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
      this.$store.commit("battle/hideFragment", "player_skill");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/constants";
  .skill_cutin{
    position: absolute;
    top: calc(25% - 75px);
    left: calc(50% - 300px);
    height: 150px;
    width: 600px;
    opacity: 0;
    border-top: 2px solid transparent;
    border-bottom: 2px solid transparent;
    .base{
      width: 100%;
      height: 100%;
      .head{
        width: 100%;
        font-size: $font-size-large;
        margin-bottom: $space;
        text-align: center;
      }
      .images{
        position: relative;
        width: 100%;
        height: 70%;
        .background{
          width: 100%;
          height: 100%;
          background: linear-gradient(to right, #581b41 0%, transparent 160%);
        }
        .image{
          position: absolute;
          bottom: $thin_space;
          left: $space;
          height: calc(100% - #{$thin_space} * 2);
          width: 65%;
          background-position: 30% 70%;
          background-size: cover;
          background-image: url("/images/ui/velocity/rank_2.png");
        }
      }
      .descri{
        position: absolute;
        bottom: 0;
        right: 0;
        font-style: italic;
      }
    }
  }
  .anim-leave-active {
    animation: anim 1.2s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: translateX(-10px);
      background-color: transparent;
      border-top: 2px solid transparent;
      border-bottom: 2px solid transparent;
    }
    30% {
      opacity: 1;
      transform: translateX(0px);
      background-color: #75233d57;
    }
    50%{
      border-top: 2px solid #e5abec;
      border-bottom: 2px solid #e5abec;
    }
    70% {
      opacity: 1;
      transform: translateX(0px);
    }
    100% {
      opacity: 0;
      transform: translateX(30px);
      background-position-x: 0%;
      background-color: transparent;
      border-top: 2px solid transparent;
      border-bottom: 2px solid transparent;
    }
  }
</style>

<template lang="pug">
transition(name="anim")
  .skill_cutin
    .base
      .head
        | {{$store.state.battle.currentBattleSkillCutinDetail.name}}
      .images
        .background
        .image
      .descri
        | {{$store.state.battle.currentBattleSkillCutinDetail.description}}
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
    background: linear-gradient(to right, rgba(194, 194, 103, 0.623) 0%, #581b41 30%, transparent 85%, transparent 100%);
    background-size: 300% 100%;
    .base{
      width: 100%;
      height: 100%;
      .head{
        width: 100%;
        font-size: $font-size-large;
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
        bottom: $space;
        right: 0;
        font-style: italic;
        text-align: right;
        width: 75%;
      }
    }
  }
  .anim-leave-active {
    animation: anim 1.2s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: translate(-10px, 0px);
      border-top: 2px solid transparent;
      border-bottom: 2px solid transparent;
      background-position: 100% 0;
    }
    30% {
      opacity: 1;
      transform: translate(0, 0);
    }
    50%{
      border-top: 2px solid #ffa2be;
      border-bottom: 2px solid #ffa2be;
    }
    70% {
      opacity: 1;
      transform: translate(0, 0);
    }
    100% {
      opacity: 0;
      transform: translate(30px, 0px);
      border-top: 2px solid #ffa2be00;
      border-bottom: 2px solid #ffa2be00;
      background-position: 0 0;
    }
  }
</style>

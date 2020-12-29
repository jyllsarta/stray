<template lang="pug">
transition(name="anim")
  .skill_cutin
    .base
      .head
        | {{$store.state.battle.currentBattleSkillCutinDetail.name}}
      .images
        .background
        .image(:style="imageStyle")
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
      this.$store.commit("battle/hideFragment", "enemy_skill");
    },
  },
  computed: {
    imageStyle(){
      return {
        backgroundImage: `url("/images/battle/characters/${this.$store.state.battle.enemy_image_name}_normal.png")`,
      };
    }
  }
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/constants";
  .skill_cutin{
    position: absolute;
    top: calc(30% - 100px);
    left: calc(50% - 300px);
    height: 200px;
    width: 600px;
    opacity: 0;
    border-top: 2px solid transparent;
    border-bottom: 2px solid transparent;
    background: linear-gradient(to left, rgba(103, 105, 194, 0.623) 0%, #1b4058 30%, transparent 85%, transparent 100%);
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
          background: linear-gradient(to left, #1b4558 0%, transparent 160%);
        }
        .image{
          position: absolute;
          bottom: $thin_space;
          right: $space;
          height: calc(100% - #{$thin_space} * 2);
          width: 65%;
          background-position: 70% 50%;
          background-size: cover;
        }
      }
      .descri{
        position: absolute;
        bottom: $space;
        left: 0;
        font-style: italic;
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
      transform: translate(10px, 0px);
      border-top: 2px solid transparent;
      border-bottom: 2px solid transparent;
      background-position: 0% 0;
    }
    30% {
      opacity: 1;
      transform: translate(0, 0);
    }
    50%{
      border-top: 2px solid #a2d5ff;
      border-bottom: 2px solid #a2d5ff;
    }
    70% {
      opacity: 1;
      transform: translate(0, 0);
    }
    100% {
      opacity: 0;
      transform: translate(-30px, 0px);
      border-top: 2px solid #a2d5ff00;
      border-bottom: 2px solid #a2d5ff00;
      background-position: 100% 0;
    }
  }
</style>

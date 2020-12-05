<template lang="pug">
transition(name="anim")
  .skill_cutin.topic_medium
    .text
      | プレイヤースキル！
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
  .skill_cutin{
    position: absolute;
    top: calc(40% - 25px);
    left: calc(50% - 200px);
    height: 50px;
    width: 400px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .anim-leave-active {
    animation: anim 1.2s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: translateX(-10px);
    }
    30% {
      opacity: 1;
      transform: translateX(0px);
    }
    70% {
      opacity: 1;
      transform: translateX(0px);
    }
    100% {
      opacity: 0;
      transform: translateX(30px);
    }
  }
</style>

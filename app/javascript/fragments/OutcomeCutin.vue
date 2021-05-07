<template lang="pug">
transition(name="anim")
  .outcome_cutin(:class="lastAttackResult")
    .text
      | {{lastAttackResult.toUpperCase()}}
</template>

<script lang="ts">
import Constants from "../packs/constants.ts";
import store from '../packs/store.ts'

export default {
  props: {
    lastAttackResult: String,
  },
  data: function () {
    return {};
  },
  store,
  mounted(){
    this.remove();
  },
  methods: {
    remove(){
      this.$store.commit("battle/hideFragment", "battle_outcome");
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "../stylesheets/global_setting";
  .outcome_cutin{
    position: absolute;
    top: calc(40% - 15px);
    left: calc(50% - 200px);
    height: 30px;
    width: 400px;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  .win{
    border-top: 1px solid $plus;
    border-bottom: 1px solid $plus;
    background-color: $red-opacity2;
  }
  .draw{
    border-top: 1px solid $yellow;
    border-bottom: 1px solid $yellow;
    background-color: $yellow-opacity2;
  }
  .lose{
    border-top: 1px solid $minus;
    border-bottom: 1px solid $minus;
    background-color: $blue-opacity2;
  }
  .anim-leave-active {
    animation: anim 0.6s;
  }
  @keyframes anim {
    0% {
      opacity: 0;
      transform: translateX(-10px) scale(1.3);
    }
    20% {
      opacity: 1;
      transform: translateX(0px) scale(1);
    }
    80% {
      opacity: 1;
      transform: translateX(0px);
    }
    100% {
      opacity: 0;
      transform: translateX(30px);
    }
  }
</style>

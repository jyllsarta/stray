<template lang="pug">
  .velocity.window.floating_window
    .background(:class="velocityRankClass")
    .values
      .index
        | 探索速度：
      .value
        | {{velocity}}
    .image(:class="velocityRankClass")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Vue from 'vue'

export default {
  data: function () {
    return {
    };
  },
  store,
  computed: {
    velocity(){
      return Math.min(this.$store.state.user.status.velocity, 333);
    },
    velocityRankClass(){
      return `rank_${this.$store.getters["user/currentVelocityRank"]}`;
    },
  },
  methods: {
  },
  watch: {
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.velocity {
  width: 300px;
  top: 60px + 80px + $space * 3;
  left: $space;
  height: 50px;
  .background{
    width: 100%;
    height: 100%;
    &.rank_0{
      background: linear-gradient(to right, #545f80 0%, $background 160%);
    }
    &.rank_1{
      background: linear-gradient(to right, #547b80 0%, $background 160%);
    }
    &.rank_2{
      background: linear-gradient(to right, #807154 0%, $background 160%);
    }
    &.rank_3{
      background: linear-gradient(to right, #805462 0%, $background 160%);
    }
  }
  .values{
    position: absolute;
    top: $thin_space;
    right: $space;
    .index{
      display: inline-block;
      text-align: right;
      font-size: $font-size-mini;
    }
    .value{
      display: inline-block;
      width: 2rem;
      text-align: right;
      font-size: $font-size-normal;
    }
  }
  .image{
    position: absolute;
    bottom: $thin_space;
    left: $space;
    height: calc(100% - #{$thin_space} * 2);
    width: 65%;
    background-position: 30% 70%;
    background-size: cover;
    &.rank_0{
      background-image: url("/images/ui/velocity/rank_0.png");
    }
    &.rank_1{
      background-image: url("/images/ui/velocity/rank_1.png");
    }
    &.rank_2{
      background-image: url("/images/ui/velocity/rank_2.png");
    }
    &.rank_3{
      background-image: url("/images/ui/velocity/rank_3.png");
    }
  }
}
</style>

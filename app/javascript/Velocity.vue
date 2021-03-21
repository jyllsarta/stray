<template lang="pug">
  .velocity.window.floating_window
    .background(:class="velocityRankClass")
    .values
      .index
        | 探索速度：
      .value
        | {{velocity}}
    .particles
      transition-group(name="particle-anim")
        .particle(
          v-for="particle in particles",
          :key="particle.id",
          :style="{left: particle.x, top: particle.y}"
        )
    .image(:class="velocityRankClass")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import Vue from 'vue'

export default {
  data: function () {
    return {
      particles: []
    };
  },
  store,
  mounted(){
    setInterval(this.addParticle, 300);
  },
  computed: {
    velocity(){
      return Math.min(this.$store.state.user.status.velocity, 333);
    },
    velocityRankClass(){
      return `rank_${this.$store.getters["user/currentVelocityRank"]}`;
    },
  },
  methods: {
    addParticle(){
      if(document.visibilityState !== "visible"){
        return;
      }
      if(this.velocity < 200){
        this.particles = [];
        return;
      }
      const maxParticleCount = 5;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 300);
      const y = Math.floor(Math.random() * 50);
      this.particles.push({id: id, x: x, y: y})
    },
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
  .particles{
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    .particle{
      position: absolute;
      width: 40px;
      height: 1px;
      background-color: $gray1;
    }
  }

  .particle-anim-enter-active, .particle-anim-leave-active {
    transition: all 4s;
  }
  .particle-anim-enter {
    opacity: 0;
    transform: translateX(100px);
  }
  .particle-anim-leave-to {
    opacity: 0;
    transform: translateX(-100px);
  }
}
</style>

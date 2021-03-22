<template lang="pug">
  .particles
    transition-group(name="particle-anim")
      .particle(
        v-for="particle in particles",
        :key="particle.id",
        :style="{left: particle.x, top: particle.y}"
      )
        .cross_y
        .cross_y2
        .cross_y3

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  props: {
    turnInProgress: Boolean
  },
  data: function () {
    return {
      particles: []
    };
  },
  store,
  mounted(){
    setInterval(this.addParticle, 1200);
  },
  methods: {
    addParticle(){
      if(document.visibilityState !== "visible"){
        return;
      }
      const maxParticleCount = 4;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 700) + 162;
      const y = Math.floor(Math.random() * 100) + 150;
      this.particles.push({id: id, x: x, y: y})
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.particles{
  .particle{
    position: absolute;
    mix-blend-mode: screen;
    .cross_y{
      position: absolute;
      width: 10px;
      height: 10px;
      background-color: #f3f569dc;
      transform: scale(0.2, 4) rotate(45deg)
    }
    .cross_y2{
      position: absolute;
      width: 10px;
      height: 10px;
      background-color: #f3f56977;
      transform: rotate(20deg) scale(0.2, 2.4) rotate(45deg)
    }
    .cross_y3{
      position: absolute;
      width: 10px;
      height: 10px;
      background-color: #f3f56977;
      transform: rotate(-20deg) scale(0.2, 2.4) rotate(45deg)
    }
  }
}

.particle-anim-enter-active, .particle-anim-leave-active {
  transition: all 2s;
}
.particle-anim-enter {
  opacity: 0;
  transform: translateY(-300px);
}
.particle-anim-leave-to {
  opacity: 0;
}

</style>

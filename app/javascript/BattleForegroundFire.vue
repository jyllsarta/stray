<template lang="pug">
  .particles
    transition-group(name="particle-anim")
      .particle(
        v-for="particle in particles",
        :key="particle.id",
        :style="{left: particle.x, top: particle.y}"
      )

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
    setInterval(this.addParticle, 400);
  },
  methods: {
    addParticle(){
      if(document.visibilityState !== "visible"){
        return;
      }
      const maxParticleCount = 3;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 700) + 162;
      const y = Math.floor(Math.random() * 50) + 160;
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
    width: 5px;
    height: 5px;
    background-color: #ffb056;
    mix-blend-mode: screen;
    border-radius: 3px;
    box-shadow: 0px 0px 10px 3px #ee683fe7, 0px 0px 15px 2px #f7bc659d inset;
  }
}

.particle-anim-enter-active, .particle-anim-leave-active {
  transition: all 4s;
}
.particle-anim-enter {
  opacity: 0;
  transform: translateY(50px) scale(3);
}
.particle-anim-leave-to {
  opacity: 0.5;
  transform: translateY(-100px) scale(0);
}

</style>

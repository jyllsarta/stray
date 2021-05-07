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
      const maxParticleCount = 2;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 400) + 200;
      const y = Math.floor(Math.random() * 150) + 70;
      this.particles.push({id: id, x: x, y: y})
    }
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.particles{
  .particle{
    position: absolute;
    width: 70px;
    height: 1px;
    background-color: #7df3ed;
    mix-blend-mode: screen;
  }
}

.particle-anim-enter-active, .particle-anim-leave-active {
  transition: all 2s linear;
}
.particle-anim-enter {
  opacity: 0;
  transform: translateX(300px);
}
.particle-anim-leave-to {
  opacity: 0;
  transform: translateX(-300px);
}

</style>

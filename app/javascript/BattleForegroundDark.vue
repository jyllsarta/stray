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
    setInterval(this.addParticle, 1000);
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
    width: 40px;
    height: 40px;
    background-color: #8d889e3d;
    mix-blend-mode: screen;
    border-radius: 20px;
    box-shadow: 0px 0px 10px 3px #504f79b7, 0px 0px 15px 2px #504f79b7 inset;
  }
}

.particle-anim-enter-active, .particle-anim-leave-active {
  transition: all 4s linear;
}
.particle-anim-enter {
  opacity: 1;
  transform: translateY(30px) scale(0);
}
.particle-anim-leave-to {
  opacity: 0;
  transform: translateY(10px) scale(2);
}

</style>

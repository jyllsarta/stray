<template lang="pug">
  .background_fields(:class="turnInProgress ? 'zoomed' : 'normal'")
    .floor
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
      const maxParticleCount = 5;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 600) + 212;
      const y = Math.floor(Math.random() * 100) + 50;
      this.particles.push({id: id, x: x, y: y})
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.background_fields{
  position: absolute;
  width: 100%;
  height: 100%;
  .floor {
    position: absolute;
    width: 70%;
    height: 70%;
    left: 15%;
    top: -25%;
    transform: perspective(1000px) rotateX(85deg);
    transform-origin: bottom center;
    background-image: linear-gradient(to bottom, $background 30%, $gray3 100%);
  }
  .particles{
    .particle{
      position: absolute;
      width: 2px;
      height: 60px;
      background-color: $gray1;
    }
  }
}

.zoomed{
  transition: transform 0.6s;
  transform: scale(1.3);
}
.normal{
  transition: transform 0.6s;
  transform: scale(1);
}

.particle-anim-enter-active, .particle-anim-leave-active {
  transition: all 4s;
}
.particle-anim-enter {
  opacity: 0;
  transform: translateY(100px) scale(0, 1);
}
.particle-anim-leave-to {
  opacity: 0;
  transform: translateY(-100px) scale(0, 3);
}

</style>

<template lang="pug">
  .foreground_fields(:class="turnInProgress ? 'zoomed' : 'normal'")
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
      const maxParticleCount = 2;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 800) + 112;
      const y = Math.floor(Math.random() * 30) + 200;
      this.particles.push({id: id, x: x, y: y})
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.foreground_fields{
  position: relative;
  width: 100%;
  height: 100%;
  .particles{
    .particle{
      position: absolute;
      width: 20px;
      height: 20px;
      background-color: #9fa0e077;
      mix-blend-mode: screen;
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
  transition: all 3s;
}
.particle-anim-enter {
  opacity: 0;
  transform: translateY(40px) scale(0, 1);
}
.particle-anim-leave-to {
  opacity: 0;
  transform: translateY(-40px) scale(0, 1.5);
}

</style>

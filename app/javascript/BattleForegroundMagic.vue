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
    setInterval(this.addParticle, 500);
  },
  methods: {
    addParticle(){
      if(document.visibilityState !== "visible"){
        return;
      }
      const maxParticleCount = 8;
      if(this.particles.length > maxParticleCount){
        this.particles = this.particles.slice(-maxParticleCount)
      }
      const id = Math.floor(Math.random() * 999999999);
      const x = Math.floor(Math.random() * 700) + 162;
      const y = Math.floor(Math.random() * 100) + 50;
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
    width: 10px;
    height: 10px;
    background-color: #fac7e542;
    box-shadow: 0px 0px 3px 2px #eac1f5c5;
    mix-blend-mode: screen;
  }
}

.particle-anim-enter-active, .particle-anim-leave-active {
  transition: all 5s linear;
}
.particle-anim-enter {
  opacity: 0;
  transform: translateY(-100px) rotate(545deg) rotate(45deg);
}
.particle-anim-leave-to {
  opacity: 0;
  transform: translateY(100px) rotate(-545deg) rotate(45deg);
}

</style>

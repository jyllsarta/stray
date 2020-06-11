<template lang="pug">
  .effects
    .effect(v-for="effect in effects", :key="effect.id")
      .light(:style="{left: effect.light.x, top: effect.light.y}")
      .flicker(:style="{left: effect.flickers[0].x, top: effect.flickers[0].y, transform: `rotate(${effect.flickers[0].rot}deg)`}")
      .flicker(:style="{left: effect.flickers[1].x, top: effect.flickers[1].y, transform: `rotate(${effect.flickers[1].rot}deg)`}")
      .flicker(:style="{left: effect.flickers[2].x, top: effect.flickers[2].y, transform: `rotate(${effect.flickers[2].rot}deg)`}")
      .flicker(:style="{left: effect.flickers[3].x, top: effect.flickers[3].y, transform: `rotate(${effect.flickers[3].rot}deg)`}")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      effects: [],
    };
  },
  mounted(){
    document.body.addEventListener("click", this.addClickEffect, false);
    setInterval(this.removeOldEffect, 2000);
  },
  props: {
  },
  store,
  watch: {
  },
  methods: {
    addClickEffect(e){
      let flickers = [];

      for(let i=0;i<4;++i){
        flickers.push(this.getRandomFlicker(e.clientX, e.clientY))
      }

      this.effects.push({
        id: Math.random() * 999999999,
        flickers: flickers,
        light: {x: e.clientX - 10, y: e.clientY - 10},
        createdAt: new Date().getTime(),
      });
    },
    getRandomFlicker(baseX, baseY){
      return {
        x: baseX + (Math.random() - 0.5) * 30 - 2.5,
        y: baseY + (Math.random() - 0.5) * 30 - 7.5,
        rot: Math.random() * 360,
      }
    },
    removeOldEffect(){
      console.log(`${this.effects.length} -> ${this.effects.filter((x)=>(new Date().getTime() - x.createdAt < 800)).length}`)
      this.effects = this.effects.filter((x)=>(new Date().getTime() - x.createdAt < 1800));
    }
  }
}
</script>

<style lang="scss" scoped>
  .effects {
    position: fixed;
  }
  .effect{
    position: fixed;
    .flicker{
      position: fixed;
      animation: swing-in .8s cubic-bezier(.88,.32,.72,.47) 0s;
      width: 5px;
      height: 15px;
      isolation: isolate;
      mix-blend-mode: screen;
      background-color: #def1ff;
      opacity: 0;
    }
    .light{
      position: fixed;
      animation: light-up .2s cubic-bezier(.88,.32,.72,.47) 0s;
      width: 20px;
      height: 20px;
      isolation: isolate;
      mix-blend-mode: screen;
      background-color: #def1ff;
      opacity: 0;
      transform: rotate(45deg);
    }
  }

  @keyframes swing-in {
    0% {
      opacity: 0.7;
      transform: scale(0.9);
    }
    10% {
      opacity: 1;
      transform: scale(1);
    }
    90% {
      opacity: 0.8;
      transform: scale(0.8);
    }
    100% {
      opacity: 0;
      transform: scale(0.7);
    }
  }

  @keyframes light-up {
    0% {
      opacity: 0.4;
    }
    30% {
      opacity: 0.6;
    }
    100% {
      opacity: 0;
    }
  }
</style>

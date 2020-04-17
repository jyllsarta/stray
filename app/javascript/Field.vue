<template lang="pug">
  .field
    .background.view0(
      :style="viewStyle(0)"
    )
    .background.view1(
      :style="viewStyle(1)"
    )
    .background.view2(
      :style="viewStyle(2)"
    )
    .ground
      img.spica(
        :src="spicaImagePath"
        :style="{transform: 'translateX(' + $store.state.field.position.spica + 'px) scale('+ $store.state.field.direction.spica * -1 +', 1)'}"
      )
      img.tirol(
        :src="tirolImagePath"
        :style="{transform: 'translateX(' + $store.state.field.position.tirol + 'px) scale('+ $store.state.field.direction.tirol * -1 +', 1)'}"
      )
    .background.view3(
      :style="viewStyle(3)"
    )
    .background.view4(
      :style="viewStyle(4)"
    )
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      layerStatus: {
        0: 100,
        1: 200,
        2: 300,
        3: 400,
        4: 500,
      },
      scrollAmount: {
        0: 0.003,
        1: 0.005,
        2: 0.013,
        3: 0.017,
        4: 0.030,
      },
      maxScrollPosition: 3500,
    };
  },
  store,
  mounted(){
    this.init();
    this.reseedScene();
  },
  methods: {
    init(){
      this.update();
    },
    update(){
      this.proceedCharacter();
      this.scroll();
      requestAnimationFrame(this.update);
    },
    proceedCharacter(){
      ["spica", "tirol"].forEach((name)=>{
         if(!this.$store.getters['user/isAliveCharacter'](name)){
           return;
         }
        // TODO: スピード制御ロジック
        // TODO: speedと反射基準点をcontantsから拾う
        this.$store.commit("field/moveCharacter", {characterName: name, delta: 1});
        if(this.$store.state.field.position[name] > Constants.window.ground.right){
          this.$store.commit("field/reflectCharacter", {characterName: name});
        }
        if(this.$store.state.field.position[name] < Constants.window.ground.left){
          this.$store.commit("field/reflectCharacter", {characterName: name});
        }
      });
    },
    reseedScene(){
      // 3500以上は世界の果てが見えちゃう
      for(let i=0; i<5; ++i){
        this.layerStatus[i] = Math.floor(Math.random() * (this.maxScrollPosition - 100));
      }
    },
    scroll(){
      for(let i=0; i<5; ++i){
        this.layerStatus[i] += this.scrollAmount[i];
        if(this.layerStatus[i] > this.maxScrollPosition){
          this.layerStatus[i] = this.maxScrollPosition;
        }
      }
    },
    viewStyle(viewId){
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/${viewId}.png")`,
        backgroundPosition: `-${this.layerStatus[viewId]}px 0`,
      }
    },
  },
  computed: {
    spicaImagePath(){
      return this.$store.getters['user/isAliveCharacter']('spica') ? "images/ui/spica.png" : "images/ui/spica_dead.png";
    },
    tirolImagePath(){
      return this.$store.getters['user/isAliveCharacter']('tirol') ? "images/ui/tirol.png" : "images/ui/tirol_dead.png";
    },
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.field{
  .background{
    position: absolute;
    width: $window-width;
    height: $window-height;
    background-repeat: no-repeat;
    background-size: cover;
    background-position: -500px 0;
    image-rendering: pixelated;
  }
  .ground{
    position: absolute;
    bottom: 50px + $space * 2;
    height: 200px;
    left: 50%;
    img{
      image-rendering: crisp-edges;
      position: absolute;
      height: 200px;
    }
  }
  .view3{
    mix-blend-mode: screen;
  }
}
</style>

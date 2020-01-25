<template lang="pug">
  .field
    .ground
      img.siroko(
        src="images/ui/spica.png"
        :style="{transform: 'translateX(' + $store.state.ui.position.siroko + 'px) scale('+ $store.state.ui.direction.siroko * -1 +', 1)'}"
      )
      img.kuroko(
        src="images/ui/tirol.png"
        :style="{transform: 'translateX(' + $store.state.ui.position.kuroko + 'px) scale('+ $store.state.ui.direction.kuroko * -1 +', 1)'}"
      )
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {};
  },
  store,
  mounted(){
    this.init();
  },
  methods: {
    init(){
      this.update();
    },
    update(){
      this.proceedCharacter();
      requestAnimationFrame(this.update);
    },
    proceedCharacter(){
      ["siroko", "kuroko"].forEach((name)=>{
        // TODO: スピード制御ロジック
        // TODO: speedと反射基準点をcontantsから拾う
        this.$store.commit("moveCharacter", {characterName: name, delta: 1});
        if(this.$store.state.ui.position[name] > Constants.window.ground.right){
          this.$store.commit("reflectCharacter", {characterName: name});
        }
        if(this.$store.state.ui.position[name] < Constants.window.ground.left){
          this.$store.commit("reflectCharacter", {characterName: name});
        }
      });
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/constants";
.field{
  .ground{
    position: absolute;
    bottom: 100px + $space * 2;
    height: 200px;
    left: 50%;
    img{
      position: absolute;
      height: 200px;
    }
  }
}
</style>

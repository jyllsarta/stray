<template lang="pug">
  .field
    .ground
      img.spica(
        src="images/ui/spica.png"
        :style="{transform: 'translateX(' + $store.state.field.position.spica + 'px) scale('+ $store.state.field.direction.spica * -1 +', 1)'}"
      )
      img.tirol(
        src="images/ui/tirol.png"
        :style="{transform: 'translateX(' + $store.state.field.position.tirol + 'px) scale('+ $store.state.field.direction.tirol * -1 +', 1)'}"
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
      ["spica", "tirol"].forEach((name)=>{
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

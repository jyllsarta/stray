<template lang="pug">
  .field
    .background.view0(
      :style="view0Style"
    )
    .background.view1(
      :style="view1Style"
    )
    .background.view2(
      :style="view2Style"
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
      :style="view3Style"
    )
    .background.view4(
      :style="view4Style"
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
  },
  computed: {
    spicaImagePath(){
      return this.$store.getters['user/isAliveCharacter']('spica') ? "images/ui/spica.png" : "images/ui/spica_dead.png";
    },
    tirolImagePath(){
      return this.$store.getters['user/isAliveCharacter']('tirol') ? "images/ui/tirol.png" : "images/ui/tirol_dead.png";
    },
    view0Style(){
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/0.png")`
      }
    },
    view1Style(){
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/1.png")`
      }
    },
    view2Style(){
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/2.png")`
      }
    },
    view3Style(){
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/3.png")`
      }
    },
    view4Style(){
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/4.png")`
      }
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

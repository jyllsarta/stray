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
      .hover_animator(:style="{transform: `translate(0, -${characters.spica.hoverHeight}px)`}")
        img.spica(
          :src="spicaImagePath"
          :style="{transform: `translate(${characters.spica.position}px, ${characters.spica.verticalPosition}px) scale(${characters.spica.direction}, 1)`}"
          @click="clickSpica"
        )
      .hover_animator(:style="{transform: `translate(0, -${characters.tirol.hoverHeight}px)`}")
        img.tirol(
          :src="tirolImagePath"
          :style="{transform: `translate(${characters.tirol.position}px, ${characters.tirol.verticalPosition}px) scale(${characters.tirol.direction}, 1)`}"
          @click="clickTirol"
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
      frameCount : 0,
      characters: {
        spica: {
          position: 30,
          speed: 0,
          direction: 1,
          verticalPosition: 1,
          verticalVelocity: 0,
          hoverHeight: 0,
        },
        tirol: {
          position: -70,
          speed: 0,
          direction: 1,
          verticalPosition: 1,
          verticalVelocity: 0,
          hoverHeight: 0,
        },
      },
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
      this.frameCount++;
      requestAnimationFrame(this.update);
    },
    jumpSpica(){
      if(this.characters.spica.verticalVelocity != 0){
        return;
      }
      this.characters.spica.verticalVelocity += 10;
    },
    jumpTirol(){
      if(this.characters.tirol.verticalVelocity != 0){
        return;
      }
      this.characters.tirol.verticalVelocity += 8;
    },
    proceedCharacter(){
      ["spica", "tirol"].forEach((name)=>{
        if(!this.$store.getters['user/isAliveCharacter'](name)){
          return;
        }
        this.tickSpeed(name);
        if(this.characters[name].speed < Constants.window.ground.staticStateThreshold){
          this.characters[name].verticalPosition = Math.floor(Math.sin(this.frameCount / 20) * 2);
        }
        else{
          this.characters[name].position += this.characters[name].speed;
        }

        // ジャンプ
        this.characters[name].hoverHeight += this.characters[name].verticalVelocity;
        this.characters[name].verticalVelocity -= 0.5;
        if(this.characters[name].hoverHeight <= 0){
          this.characters[name].hoverHeight = 0;
          this.characters[name].verticalVelocity = 0;
        }
      });
    },
    tickSpeed(characterName){
      let speed = this.characters[characterName].speed;
      speed += (Math.random() - 0.5) * Constants.window.ground.speedDelta;

      // スピードがつきすぎてたら減速
      if(Math.abs(speed) > 1){
        speed /= 2;
      }

      //端に寄りすぎてたら反対側に引っ張る
      if(this.characters[characterName].position > Constants.window.ground.right){
        speed -= 1;
      }
      if(this.characters[characterName].position < Constants.window.ground.left){
        speed += 1;
      }

      // 移動閾値を超えていたらその方向を向かせる
      if(this.characters[characterName].speed > Constants.window.ground.staticStateThreshold){
        this.characters[characterName].direction = -1;
      }
      if(this.characters[characterName].speed < -Constants.window.ground.staticStateThreshold){
        this.characters[characterName].direction = 1;
      }

      this.characters[characterName].speed = speed;
    },
    reseedScene(){
      this.$store.commit('window/updateWindowShowState', {windowName: 'transition_frame', state: true});
      setTimeout(()=>{
        this.randomisePosition();
        this.$store.commit('window/updateWindowShowState', {windowName: 'transition_frame', state: false});
      }, 650)
    },
    randomisePosition(){
      // 3500以上は世界の果てが見えちゃう
      for(let i=0; i<5; ++i){
        this.layerStatus[i] = Math.floor(Math.random() * (this.maxScrollPosition - 100));
      }
      ["spica", "tirol"].forEach((name)=>{
        const field = Constants.window.ground;
        const pos = (Math.random() - 0.5) * ( field.right - field.left) + (field.right + field.left);
        this.characters[name].position = pos;
      });
    },
    scroll(){
      if(!this.$store.getters['user/isAliveCharacter']("spica") || !this.$store.getters['user/isAliveCharacter']("tirol")){
        return;
      }
      for(let i=0; i<5; ++i){
        this.layerStatus[i] += this.scrollAmount[i];
        if(this.layerStatus[i] > this.maxScrollPosition){
          this.layerStatus[i] = this.maxScrollPosition;
        }
      }
    },
    viewStyle(viewId){
      const opacity = viewId === 3 ? Math.abs(Math.sin(this.layerStatus[viewId] / 20)) * 0.7 + 0.3 : 1;
      return {
        backgroundImage: `url("/images/backgrounds/${this.$store.state.user.status.current_dungeon_id}/${this.scapeId()}-${viewId}.png")`,
        backgroundPosition: `-${Math.floor(this.layerStatus[viewId])}px 0`,
        opacity: opacity,
      }
    },
    clickSpica(){
      this.jumpSpica();
      this.clickCharacter();
    },
    clickTirol(){
      this.jumpTirol();
      this.clickCharacter();
    },
    clickCharacter(){
      const achievementId = Constants.achievements.ids.clickFieldCharacter;
      if( this.$store.state.achievement.loading || this.$store.state.achievement.user_achievements[achievementId]?.progress >= 1 ){
        return;
      }
      this.$store.dispatch('achievement/sendClientAchievement', "click_field_character").then(()=>{
        this.$store.dispatch("achievement/fetchAchievements");
        this.$store.dispatch("achievement/fetchAchievementCache");
      });
    },
    scapeId(){
      return (Math.floor(this.$store.state.user.status.current_dungeon_depth / 100) % 4 + 1) || 1;
    },
  },
  computed: {
    spicaImagePath(){
      if(!this.$store.getters['user/isAliveCharacter']('spica')){
        return "images/ui/spica_dead.png";
      }
      if(this.characters.spica.hoverHeight !== 0){
        return "images/ui/spica_ukya.png"
      }
      return "images/ui/spica.png";
    },
    tirolImagePath(){
      if(!this.$store.getters['user/isAliveCharacter']('tirol')){
        return "images/ui/tirol_dead.png";
      }
      if(this.characters.tirol.hoverHeight !== 0){
        return "images/ui/tirol_ukya.png"
      }
      return "images/ui/tirol.png";
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
    pointer-events: none;
  }
  .ground{
    position: absolute;
    bottom: 50px + $space * 2;
    height: 200px;
    left: 50%;
    .hover_animator{
      img{
        image-rendering: pixelated;
        position: absolute;
        height: 200px;
        cursor: pointer;
      }
    }
  }
  .view3{
    mix-blend-mode: screen;
  }
}
</style>

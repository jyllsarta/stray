<template lang="pug">
  .images
    transition(name="showing")
      img.showing.character.waiting(:src="normalImagePath" v-if="status === 'waiting'" :style="{animationDuration: duration + 's'}" :class="characterClass")
    transition(name="showing")
      img.showing.character.normal(:src="normalImagePath" v-if="status === 'normal'" :class="characterClass")
    transition(name="showing")
      img.showing.character.attack(:src="attackImagePath" v-if="status === 'attack'" :class="characterClass" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.attack2(:src="attack2ImagePath" v-if="status === 'attack2'" :class="characterClass" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.attack3(:src="attack3ImagePath" v-if="status === 'attack3'" :class="characterClass" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.draw(:src="drawImagePath" v-if="status === 'draw'" :class="characterClass" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.lose(:src="loseImagePath" v-if="status === 'lose'" :class="characterClass" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.magic(:src="magicImagePath" v-if="status === 'magic'" :class="characterClass" :key="currentSkillName")
    transition(name="showing")
      img.shield(
        v-if="shield"
        src="/images/battle/barrier.png"
        :style="{transform: `translateX(${isPlayer ? playerBarrierPosition : enemyBarrierPosition}px) scale(${isPlayer ? 1 : -1} ,1)`}"
        :key="`${characterName}${isPlayer ? playerBarrierPosition : enemyBarrierPosition}`"
        )

</template>

<script lang="ts">
export default {
  props: {
    characterName: String,
    images: {
      normal: String,
      attack: String,
      attack2: String,
      attack3: String,
      draw: String,
      lose: String,
      magic: String,
      default: String,
    },
    reversed: Boolean,
    shield: Boolean,
    isPlayer: Boolean,
    status: String,
    currentSkillName: String,
  },
  data: () => {
    return {
      duration: 4
    }
  },
  mounted() {
    const multiplier = this.isPlayer ? 1 : 4;
    this.duration = (Math.random() - 0.5) * multiplier + 3;
  },
  computed: {
    characterClass(){
      return `${this.isPlayer ? 'player' : 'enemy'}`
    },
    normalImagePath(){
        if(!this.images.normal){
            return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
        }
        return `/images/battle/characters/${this.characterName}_${this.images.normal}.png`
    },
    attackImagePath(){
      if(!this.images.attack){
        return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
      }
      return `/images/battle/characters/${this.characterName}_${this.images.attack}.png`
    },
    attack2ImagePath(){
      if(!this.images.attack2){
        return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
      }
      return `/images/battle/characters/${this.characterName}_${this.images.attack2}.png`
    },
    attack3ImagePath(){
      if(!this.images.attack3){
        return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
      }
      return `/images/battle/characters/${this.characterName}_${this.images.attack3}.png`
    },
    drawImagePath(){
        if(!this.images.draw){
            return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
        }
        return `/images/battle/characters/${this.characterName}_${this.images.draw}.png`
    },
    loseImagePath(){
        if(!this.images.lose){
            return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
        }
        return `/images/battle/characters/${this.characterName}_${this.images.lose}.png`
    },
    magicImagePath(){
        if(!this.images.magic){
            return `/images/battle/characters/${this.characterName}_${this.images.default}.png`
        }
        return `/images/battle/characters/${this.characterName}_${this.images.magic}.png`
    },
    playerBarrierPosition(){
        switch(this.status){
          case "waiting":
            return 30;
          case "normal":
            return 30;
          case "attack":
            return 175;
          case "attack2":
            return 175;
          case "attack3":
            return 175;
          case "draw":
            return 50;
          case "lose":
            return -10;
          case "magic":
            return 30;
        }
    },
    enemyBarrierPosition(){
        switch(this.status){
          case "waiting":
            return -30;
          case "normal":
            return -30;
          case "attack":
            return -175;
          case "attack2":
            return -175;
          case "attack3":
            return -175;
          case "draw":
            return -50;
          case "lose":
            return 10;
          case "magic":
            return -30;
        }
    }
  }
}
</script>

<style lang="scss" scoped>
.images{
  .character{
    position: absolute;
    width: 256px;
    height: 256px;
    image-rendering: pixelated;
  }

  .shield{
    position: absolute;
    width: 256px;
    height: 256px;
  }

  .waiting{
    animation-name: waving;
    animation-iteration-count: infinite;
  }

  @keyframes waving {
    0% {
      transform: translateY(0px) scale(0.7);
    }
    25% {
      transform: translateY(1px) scale(0.7);
    }
    75% {
      transform: translateY(-1px) scale(0.7);
    }
    100% {
      transform: translateY(0px) scale(0.7);
    }
  }

  // 多少冗長だけど、まあこれでいいか
  .player.waiting{
    left: -20px;
    top: 40px;
  }
  .player.normal{
    left: 0;
  }
  .player.attack{
    left: 145px;
  }
  .player.attack2{
    left: 145px;
  }
  .player.attack3{
    left: 145px;
  }
  .player.draw{
    left: 20px;
  }
  .player.lose{
    left: -40px;
  }
  .player.magic{
    left: 0;
  }
  .player.shield{
    left: 20px;
  }

  .enemy.waiting{
    left: 40px;
    top: 50px;
  }
  .enemy.normal{
    left: 0;
  }
  .enemy.attack{
    left: -145px;
  }
  .enemy.draw{
    left: -20px;
  }
  .enemy.lose{
    left: 40px;
  }
  .enemy.magic{
    left: 0;
  }
  .enemy.shield{
    left: -20px;
  }
}

.showing-enter-active {
  transition: all .4s;
}
.showing-leave-active {
  transition: all .4s;
}
.showing-enter{
  transform: translateX(-30px);
  opacity: -0.5;
}
.showing-leave-to{
  transform: translateX(-30px);
  opacity: 0;
}

</style>

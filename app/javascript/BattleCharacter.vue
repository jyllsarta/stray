<template lang="pug">
  .images
    transition(name="showing")
      img.showing.character.normal.stay(:src="normalImagePath" v-if="status === 'normal'" :style="{animationDelay: delay + 's', animationDuration: duration + 's'}" :class="isPlayer ? 'player' : 'enemy'")
    transition(name="showing")
      img.showing.character.attack(:src="attackImagePath" v-if="status === 'attack'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.draw(:src="drawImagePath" v-if="status === 'draw'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.lose(:src="loseImagePath" v-if="status === 'lose'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.magic(:src="magicImagePath" v-if="status === 'magic'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
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
      delay: 2,
      duration: 4
    }
  },
  mounted() {
    this.delay = Math.random() * 2;
    this.duration = Math.random() + 3;
  },
  computed: {
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
            case "normal":
                return 30;
            case "attack":
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
            case "normal":
                return -30;
            case "attack":
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

  .stay{
    animation-name: waving;
    animation-iteration-count: infinite;

  }

  @keyframes waving {
    0% {
      transform: translateY(0px);
    }
    25% {
      transform: translateY(1px);
    }
    75% {
      transform: translateY(-1px);
    }
    100% {
      transform: translateY(0px);
    }
  }

  // 多少冗長だけど、まあこれでいいか
  .player.normal{
    left: 0;
  }
  .player.attack{
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
  transition: all .3s;
}
.showing-leave-active {
  transition: all .3s;
}
.showing-enter{
  transform: translateX(-30px);
  opacity: 0;
}
.showing-leave-to{
  transform: translateX(-30px);
  opacity: 0;
}

</style>

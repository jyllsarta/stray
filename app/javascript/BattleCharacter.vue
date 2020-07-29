<template lang="pug">
  .images
    transition(name="showing")
      img.showing.character.normal(:src="normalImagePath" v-if="status === 'normal'" :class="isPlayer ? 'player' : 'enemy'")
    transition(name="showing")
      img.showing.character.attack(:src="attackImagePath" v-if="status === 'attack'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.draw(:src="drawImagePath" v-if="status === 'draw'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.lose(:src="loseImagePath" v-if="status === 'lose'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
    transition(name="showing")
      img.showing.character.magic(:src="magicImagePath" v-if="status === 'magic'" :class="isPlayer ? 'player' : 'enemy'" :key="currentSkillName")
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
    barrier: Boolean,
    isPlayer: Boolean,
    status: String,
    currentSkillName: String,
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
  }
}
</script>

<style lang="scss" scoped>
.images{
  .character{
    position: absolute;
    width: 256px;
    height: 256px;
  }

  // 多少冗長だけど、まあこれでいいか
  .player.normal{
    left: 0;
  }
  .player.attack{
    left: 85px;
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
  .enemy.normal{
    left: 0;
  }
  .enemy.attack{
    left: -85px;
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

<template lang="pug">
  .images
    img.character.normal(:src="normalImagePath" v-if="status === 'normal'")
    img.character.normal(:src="attackImagePath" v-if="status === 'attack'")
    img.character.normal(:src="drawImagePath" v-if="status === 'draw'")
    img.character.normal(:src="loseImagePath" v-if="status === 'lose'")
    img.character.normal(:src="magicImagePath" v-if="status === 'magic'")
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
    status: String,
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
    width: 256px;
    height: 256px;
  }
}
</style>

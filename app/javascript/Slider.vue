<template lang="pug">
.bar(:class="sliderClass" :style="{width: width}")
  .on(:style="{width: mainWidth, height: height, backgroundColor: mainColor}")
  .blank(:style="{width: mainWidth, height: height, backgroundColor: blankColor}")
</template>

<script lang="ts">
export default {
  props: {
    width: Number,
    height: Number,
    ratio: Number,
    mainColor: String,
    blankColor: String,
    reversed: Boolean,
  },
  computed: {
    mainWidth(){
      if(this.ratio < 0){
          return 0;
      }
      return this.width * this.ratio;
    },
    sliderClass(){
      if(this.reversed){
        return "reversed";
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .bar{
    display: flex;
    border-radius: 1px;
    .on{
      height: 100%;
    }
    .blank{
      height: 100%;
      flex: 1;
    }
  }
  .reversed{
    flex-direction: row-reverse;
  }
</style>

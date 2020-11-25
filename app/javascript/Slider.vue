<template lang="pug">
.bar(:style="{width: width, height: height}")
  .on(:class="sliderClass")
    .active(:style="{width: mainWidth, backgroundColor: mainColor}")
    .damage(:style="{width: damageWidth, backgroundColor: '#FFFFFF'}")
  .blank(:style="{width: width, backgroundColor: blankColor}")
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
  data() {
    return {
      ratioFluctuation: 0,
      updateRatio: 0.1, // 毎フレーム何％目標値に近づけるか
    };
  },
  computed: {
    mainWidth(){
      if(this.ratio < 0){
        return 0;
      }
      if(this.ratio > 1){
        return this.width;
      }
      return this.width * this.ratio;
    },
    damageWidth(){
      if(this.ratioFluctuation < 0){
        return 0;
      }
      if(this.ratioFluctuation > 1){
        return this.width;
      }
      return this.width * this.ratioFluctuation;
    },
    sliderClass(){
      if(this.reversed){
        return "reversed";
      }
    }
  },
  watch: {
    "ratio": {
      handler: function(newVal, oldVal){
        // 外側から外側への移動は関与しなくて良い
        if((newVal < 0 && oldVal <= 0) || (newVal > 1 && oldVal >= 1)){
          return;
        }
        // 減ったら減った分だけマイナスの履歴を残す
        if(newVal < oldVal){
          this.ratioFluctuation += oldVal - newVal;
        }
        setTimeout(()=>this.react(), 300);
      }
    },
  },
  methods:{
    react(){
      this.ratioFluctuation = this.ratioFluctuation * (1 - this.updateRatio);
      if(this.ratioFluctuation < 0.01){
        this.ratioFluctuation = 0;
      }
      else{
        setTimeout(()=>this.react(), 20);
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .bar{
    position: relative;
    .on{
      position: absolute;
      display: flex;
      height: 100%;
      width: 100%;
      .active, .damage{
        height: 100%;
      }
    }
    .blank{
      position: absolute;
      height: 100%;
      flex: 1;
    }
  }
  .reversed{
    flex-direction: row-reverse;
  }
</style>

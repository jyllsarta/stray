<template lang="pug">
.bar(:style="{width: width, height: height}")
  .on(:class="sliderClass")
    .active(:style="{width: mainWidth, backgroundColor: mainColor }")
    // プラス領域を光らせるならこれ
    //.plus(:style="{width: plusWidth, backgroundColor: mainColor }")
    .damage(:style="{width: damageWidth, backgroundColor: damageColor}")
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
    damageColor: String,
    reversed: Boolean,
    updateDelayms: Number, 
    updateRatio: Number,
  },
  data() {
    return {
      damageRatioFluctuation: 0,
      plusRatioFluctuation: 0,
      tickHandler: 0,
    };
  },
  beforeDestroy(){
    clearInterval(this.tickHandler);
  },
  computed: {
    mainWidth(){
      if(this.ratio < 0){
        return 0;
      }
      if(this.ratio > 1){
        return this.width;
      }
      return this.width * (this.ratio - this.plusRatioFluctuation);
    },
    damageWidth(){
      const fluctuation = this.damageRatioFluctuation;
      if(fluctuation < 0){
        return 0;
      }
      if(fluctuation > 1){
        return this.width;
      }
      return this.width * fluctuation;
    },
    plusWidth(){
      const fluctuation = this.plusRatioFluctuation;
      if(fluctuation < 0){
        return 0;
      }
      if(fluctuation > 1){
        return this.width;
      }
      return this.width * fluctuation;
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
          const before = Math.min(oldVal, 1);
          const after = Math.max(newVal, 0);
          this.damageRatioFluctuation += before - after;
        }
        // 増えたらプラスの履歴を残す
        if(newVal > oldVal){
          const before = Math.max(oldVal, 0);
          const after = Math.min(newVal, 1);
          this.plusRatioFluctuation += after - before;
        }
        clearInterval(this.tickHandler);
        this.tickHandler = setTimeout(()=>this.react(), this.updateDelayms || 300);
      }
    },
  },
  methods:{
    react(){
      this.damageRatioFluctuation = this.damageRatioFluctuation * (1 - (this.updateRatio || 0.1));
      this.plusRatioFluctuation = this.plusRatioFluctuation * (1 - (this.updateRatio || 0.1));
      if(this.damageRatioFluctuation < 0.01){
        this.damageRatioFluctuation = 0;
      }
      if(this.plusRatioFluctuation < 0.01){
        this.plusRatioFluctuation = 0;
      }
      if(this.damageRatioFluctuation > 0 || this.plusRatioFluctuation > 0){
        this.tickHandler = setTimeout(()=>this.react(), 20);
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
      .active, .damage, .plus{
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

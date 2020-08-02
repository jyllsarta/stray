<template lang="pug">
.number
  | {{Math.floor(currentNumber)}}
</template>

<script lang="ts">
export default {
  props: {
    number: Number,
    speed: Number
  },
  data: ()=>{
    return {
      currentNumber: -1,
      updateRatio: 0.1, // 毎フレーム何％目標値に近づけるか
    }
  },
  computed: {
  },
  mounted() {
    this.currentNumber = this.number;
    if(this.speed){
      this.updateRatio = this.speed;
    }
  },
  watch: {
    number(){
      this.react();
    },
  },
  methods:{
    react(){
      this.currentNumber = (1 - this.updateRatio) * this.currentNumber + (this.updateRatio) * this.number;
      if(Math.abs(this.currentNumber - this.number) < 0.8){
        this.currentNumber = this.number;
      }
      if(Math.floor(this.currentNumber) != Math.floor(this.number)){
        setTimeout(()=>this.react(), 20);
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

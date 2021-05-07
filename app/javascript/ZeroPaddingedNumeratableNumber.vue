<template lang="pug">
.number
  span.zeros
    | {{zeros}}
  span.num
    | {{mainNumber}}
</template>

<script lang="ts">
export default {
  props: {
    digits: Number,
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
    zeros() {
      const mainDigits = this.currentNumber > 0 ? Math.floor(this.currentNumber).toString().length : 0;
      const zeroCount = this.digits - mainDigits;
      return "0".repeat(zeroCount);
    },
    mainNumber(){
      return this.currentNumber > 0 ?  Math.floor(this.currentNumber) : "";
    }
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
  .zeros{
    opacity: 0.5;
  }
</style>

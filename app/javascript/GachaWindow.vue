<template lang="pug">
  .menu
    .back(@click="closeWindow")
    .window.content
      .title_area
        .back_button.clickable(@click="closeWindow")
          .arrow
        .title
          | 神秘の鍋
      .description
        | コインを投入して、溢れてくる何かを掴み取りましょう。
        | 投入額によって、ランダムなアイテムが手に入ります。現在滞在しているダンジョンの難易度によって出てくるものが変わります。
      .body
        .rates
          .index
            | - 提供割合 - 
          .table
            .item(v-for="rate, index in rarityObjects")
              .rarity(:class="`rarity${index + 1}`")
                | {{ rate.symbol }}
              .rate
                // *100 で % に変換, * 100 / 100 で小数第二位
                | {{Math.round(rate.rate * 100 * 100) / 100}}%
        .controls
          .line
            .label
              | 所持：
            img.icon(src="/images/ui/coin.png")
            .value
              | {{estimatedCurrent}}
            .buttons
              .button(@click="resetPool", :class="poolValue > 0 ? 'clickable' : 'not_clickable'")
                | 戻す
          .line
            .label
              | 投入：
            img.icon(src="/images/ui/coin.png")
            .value
              input.pool_text(v-model="pool" @blur="calibratePool")
            .buttons
              .button(@click="addPoolSingle", :class="poolValue !== gacha.limit ? 'clickable' : 'not_clickable'")
                | +{{this.gacha.limit / 10}}
              .button(@click="addPoolMax", :class="poolValue !== gacha.limit ? 'clickable' : 'not_clickable'")
                | MAX
          .line
            .label
              | 累計：
            img.icon(src="/images/ui/coin.png")
            .value
              | {{estimatedTotal}}
            .buttons
              .button(@click="doGacha", :class="poolValue > 0 ? 'clickable' : 'not_clickable'")
                | 投入！
        .rewards
          .index
            | 　　　- ご利益 -
          .table
            .reward(v-for="reward in gacha.recent_fixed_rewards" :class="reward.point <= estimatedTotal  ? 'available' : ''")
              .total
                | {{reward.point}}
              img.icon(:src="`/images/ui/${reward.giftable_type.toLowerCase()}.png`")
              .cross
                | x
              .amount
                | {{reward.amount}}
        transition(name="fad")
          .darken(v-if="onResultAnimation")
        .pot(:class="onResultAnimation ? 'animating' : ''")
          img.pot_image(:src="`/images/gacha/pot${gacha.pot_grade}.png`")
        .characters
          img.tirol(src="/images/gacha/tirol.png" :class="onResultAnimation ? 'animating' : ''")
          img.spica(src="/images/gacha/spica.png" :class="onResultAnimation ? 'animating' : ''")
        .light_balls
          .ball(v-for="ball in lightBalls", :key="ball.id" :style="{transform: `translate(${ball.x}px, ${ball.y}px)`}")
            .ball_image(:class="`rarity${ball.rarity}`" :style="{animationDelay: `${ball.delay}ms`}")
        .blight_effects
          .blight(v-for="blight in blightEffects", :key="blight.id" :style="{transform: `translate(${blight.x}px, ${blight.y}px)`}")
            .blight_image(:style="{animationDelay: `${blight.delay}ms`}")
    transition(name="fad")
      .full_covered_window(v-if="showingResult")
        .random_results
          .result(v-for="reward, index in rewards.random_rewards" :class="`rarity${guessRarityFromFirstCharacter(reward)}`")
            .word
              | {{reward}}
            .hiddeners
              transition(name="gacha-result-reveal-top")
                .hiddener_upper(v-if="gachaResultRevealState[index] !== true" @mouseover="revealGachaResult(index)" :class="`rarity${guessRarityFromFirstCharacter(reward)}`")
              transition(name="gacha-result-reveal-bottom")
                .hiddener_downer(v-if="gachaResultRevealState[index] !== true" @mouseover="revealGachaResult(index)" :class="`rarity${guessRarityFromFirstCharacter(reward)}`")
        .fixed_results
          .index
            | - ご利益 -
          .results
            .result(v-for="reward in rewards.fixed_rewards")
              | {{reward}}
        .done.clickable(@click="closeGachaResult")
          | 閉じる

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import StateLibrary from './packs/quest/state_library'

export default {
  data: function () {
    return {
      gacha: {
        current_total_point: 0,
        limit: 100000,
        pot_grade: 1,
        rates: [0, 8000, 1000, 500, 250, 250],
        recent_fixed_rewards: [],
      },
      rewards: {
        fixed_rewards: [],
        random_rewards: [],
      },
      lastGachapool: 0,
      pool: 0,
      onResultAnimation: false,
      showingResult: false,
      blockPostGacha: false,
      lightBalls: [],
      blightEffects: [],
      gachaResultRevealState: [],
    };
  },
  props: {
  },
  store,
  mounted(){
    this.fetchGachaIndex();
    this.pool = 0;
  },
  computed: {
    rarityObjects(){
      let res = [];
      let raritySymbols = ["", "・", "*", "☆", "★", "◆"];
      let sumWeights = this.gacha.rates.reduce((x,y)=>x+y);
      // rarity=0は捨てる
      for(let i = 1; i < this.gacha.rates.length; ++i ){
        res.push({rarity: i, symbol: raritySymbols[i], rate: this.gacha.rates[i] / sumWeights});
      }
      return res;
    },
    poolValue(){
      return Math.min(Math.max(parseInt(this.pool) || 0, 0), this.gacha.limit);
    },
    estimatedTotal(){
      return this.poolValue + this.gacha.current_total_point;
    },
    estimatedCurrent(){
      return this.$store.state.user.status.coin - this.poolValue;
    },
  },
  methods: {
    closeWindow(){
      this.$store.dispatch("user/fetchUserModel");
      this.$store.commit('window/updateWindowShowState', {windowName: 'gacha', state: false});
    },
    fetchGachaIndex(){
      const path = `/gacha.json`;
      ax.get(path)
        .then((results) => {
          console.log(results);
          this.gacha = results.data.gacha;
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    doGacha(){
      if(this.blockPostGacha){
        console.log("通信中だよ");
        return;
      }
      if(this.pool === 0){
        console.log("空やんけ");
        return;
      }
      this.blockPostGacha = true;
      const path = `/gacha.json`;
      const params = {
        amount: this.pool,
      }
      ax.post(path, params)
        .then((results) => {
          console.log(results);
          this.rewards = results.data.rewards;
          this.gacha = results.data.gacha;
          this.lastGachapool = this.pool;
          this.gachaResultRevealState = [];
          this.pool = 0;
          this.invokeGachaAnimation();
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
          this.blockPostGacha = false;
        });      
    },
    calibratePool(){
      this.pool = parseInt(this.pool) || 0;
      this.pool = Math.min(Math.max(this.pool, 0), this.gacha.limit, this.$store.state.user.status.coin);
    },
    resetPool(){
      if(this.blockPostGacha){
        console.log("通信中だよ");
        return;
      }
      this.pool = 0;
    },
    addPoolSingle(){
      if(this.blockPostGacha){
        console.log("通信中だよ");
        return;
      }
      this.pool += this.gacha.limit / 10;
      this.calibratePool();
    },
    addPoolMax(){
      if(this.blockPostGacha){
        console.log("通信中だよ");
        return;
      }
      this.pool = this.gacha.limit;
      this.calibratePool();
    },
    guessRarityFromFirstCharacter(reweardText){
      const raritySymbols = ["x", "x", "*", "☆", "★", "◆"];
      const index = raritySymbols.indexOf(reweardText[0]);
      return index == -1 ? 1 : index;
    },
    setLightBalls(){
      this.lightBalls = [];
      for(let i = 0; i < this.rewards.random_rewards.length; ++i){
        this.lightBalls.push({
          id: Math.floor(Math.random() * 100000000),
          x: (Math.random() - 0.5) * 400,
          y: (Math.random() - 0.5) * 90,
          rarity: this.guessRarityFromFirstCharacter(this.rewards.random_rewards[i]),
          delay: i * 50,
        })
      }
    },
    setBlightEffects(){
      this.blightEffects = [];
      const effectCount = Math.max(Math.floor(20 * this.lastGachapool / this.gacha.limit), 1);
      for(let i = 0; i < effectCount; ++i){
        this.blightEffects.push({
          id: Math.floor(Math.random() * 100000000),
          x: (Math.random() - 0.5) * 300,
          y: (Math.random() - 0.5) * 30,
          delay: i * 30 + 700,
        })
      }
    },
    closeGachaResult(){
      this.showingResult = false;
      this.onResultAnimation = false;
      this.blockPostGacha = false;
    },
    revealGachaResult(index){
      console.log(index);
      this.$set(this.gachaResultRevealState, index, true);
      console.log(this.gachaResultRevealState);
    },
    // Promises

    invokeGachaAnimation(){
      this.playBlightEffectAnimation();
      this.onResultAnimation = true;
      if(this.rewards.fixed_rewards.length == 0 && this.rewards.random_rewards.length == 0){
        this.closeGachaResult();
        return;
      }
      Promise.resolve()
        .then(()=>{
          return this.waitBlightEffectAnimation();
        })
        .then(()=>{
          return this.playLightBallAnimation();
        })
        .then(()=>{
          return this.showResultWindow();
        })
    },
    playBlightEffectAnimation(){
      this.setBlightEffects();
    },
    waitBlightEffectAnimation(){
      return new Promise((resolve) => {
        setTimeout(()=>{
          resolve();
        }, 2500);
      });
    },
    playLightBallAnimation(){
      return new Promise((resolve) => {
        this.setLightBalls();
        setTimeout(()=>{
          resolve();
        }, 1500);
      });
    },
    showResultWindow(){
      return new Promise((resolve) => {
        this.showingResult = true;
        setTimeout(()=>{
          resolve();
        }, 10);
      });
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

  .full_covered_window{
    position: absolute;
    width: $window-width;
    height: $window-height;
    background-color: rgba(0,0,0,0.8);
    padding: $space;
    display: flex;
    flex-direction: column;
    align-items: center;
    .random_results{
      width: 800px;
      height: 350px;
      display: flex;
      align-items: center;
      justify-content: space-around;
      flex-wrap: wrap;
      $line-size: $font-size-large;
      .result{
        width: 50%;
        line-height: 100%;
        padding: $space;
        font-size: $line-size;
        text-align: center;
      }
      .hiddeners{
        position: relative;
        top: -$line-size;
        .hiddener_upper{
          position: absolute;
          top: -$line-size / 2;
          width: 100%;
          height: $line-size;
        }
        .hiddener_downer{
          position: absolute;
          top: $line-size / 2;
          width: 100%;
          height: $line-size;
        }
        .gacha-result-reveal-top-leave-active {
          transition: all 0.5s;
        }
        .gacha-result-reveal-top-leave-to{
          opacity: 0;
          transform: translateY(-30px) scale(2, 0);
        }
        .gacha-result-reveal-bottom-leave-active {
          transition: all 0.5s;
        }
        .gacha-result-reveal-bottom-leave-to{
          opacity: 0;
          transform: translateY(30px) scale(2, 0);
        }
        .rarity1{
          background-color: $rarity1-less;
          box-shadow: 0px 0px 5px 2px $rarity1;
        }
        .rarity2{
          background-color: $rarity2-less;
          box-shadow: 0px 0px 5px 2px $rarity2;
        }
        .rarity3{
          background-color: $rarity3-less;
          box-shadow: 0px 0px 5px 2px $rarity3;
        }
        .rarity4{
          background-color: $rarity4-less;
          box-shadow: 0px 0px 5px 2px $rarity4;
        }
        .rarity5{
          background-color: $rarity5-less;
          box-shadow: 0px 0px 5px 2px $rarity5;
        }
      }
      .rarity1{
        color: $rarity1;
      }
      .rarity2{
        color: $rarity2;
      }
      .rarity3{
        color: $rarity3;
      }
      .rarity4{
        color: $rarity4;
      }
      .rarity5{
        color: $rarity5;
      }
    }
    .fixed_results{
      height: 130px;
      width: 800px;
      .index{
        height: 20%;
        padding-bottom: $thin_space;
        margin-left: 10%;
        width: 80%;
        text-align: center;
        height: 20px;
        border-bottom: 1px solid $gray3;
      }
      .results{
        height: 80%;
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        align-items: center;
        .result{
          padding: $thin_space;
          width: 200px;
          text-align: center;
        }
      }
    }
    .done{
      width: 100px;
      @include centering($height: 50px)
    }
  }

  .fad-enter-active {
    transition: opacity 0.5s;
  }
  .fad-leave-active {
    transition: opacity 0.5s;
  }
  .fad-enter{
    opacity: 0;
  }
  .fad-leave-to{
    opacity: 0;
  }

  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }
  .body{
    width: 100%;
    height: 80%;
    *{
      //outline: 1px solid $yellow;
    }
    .rates{
      position: absolute;
      top: 120px;
      left: 30px;
      width: 200px;
      height: 180px;
      .index{
        text-align: center;
      }
      .table{
        display: flex;
        flex-direction: column;
        width: 100%;
        height: 100%;
        line-height: 120%;
        justify-content: space-around;
        .item{
          width: 100%;
          line-height: 140%;
          .rarity{
            display: inline-block;
            text-align: center;
            width: 20%;
            font-size: $font-size-large;
          }
          .rate{
            display: inline-block;
            text-align: right;
            width: 80%;
          }
        }
      }
    }
    .rewards{
      position: absolute;
      top: 120px;
      right: 30px;
      width: 250px;
      height: 180px;
      .index{
        width: 100%;
        text-align: center;
      }
      .table{
        width: 100%;
        height: 100%;
        line-height: 120%;
        display: flex;
        flex-direction: column-reverse;
        justify-content: space-around;
        .reward{
          display: flex;
          align-items: center;
          border: 1px solid transparent;
          .total{
            width: 116px;
            text-align: right;
            padding-right: 10px;
          }
          .icon{
            width: 24px;
            height: 24px;
          }
          .cross{
            width: 30px;
            text-align: center;
          }
          .amount{
            width: 80px;
            text-align: right;
            padding-right: $thin_space;
          }
        }
        .available{
          border: 1px solid $yellow;
          background-color: $gray3-opacity;
        }
      }
    }
    .controls{
      position: absolute;
      top: 137px;
      $width: 420px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 160px;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: space-between;
      .line{
        display: flex;
        width: 100%;
        height: 60px;
        align-items: center;
        .label{
          width: 70px;
        }
        .icon{
          width: 24px;
          height: 24px;
        }
        .value{
          flex: 1;
          text-align: right;
          padding-right: $space;
          font-size: $font-size-large;
          .pool_text{
            width: 100%;
            text-align: right;
            color: $white;
          }
        }
        .buttons{
          width: 180px;
          display: flex;
          .button{
            @include centering($height: 36px);
            margin: $thin_space;
            flex: 1;
          }
        }
      }
    }
    .darken{
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.8);
    }
    .pot{
      position: absolute;
      bottom: 0px;
      $width: 800px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 250px;
      display: flex;
      justify-content: space-around;
      .pot_image{
        height: 100%;
      }
      &.animating{
        animation: pot-animation 1s;
        animation-delay: 2s;
        transform-origin: bottom;
      }
      @keyframes pot-animation {
        30% {
          transform: scale(1.02, 0.99);
        }
      }
    }
    .characters{
      position: absolute;
      bottom: 0;
      $width: 950px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 160px;
      display: flex;
      justify-content: space-between;
      img{
        height: 100%;
      }
      .spica{
        &.animating{
          animation: spica-animation 1s;
          transform-origin: bottom;
        }
        @keyframes spica-animation {
          30% {
            transform: scale(1.04, 0.98) translateX(-10px);
          }
        }
      }
      .tirol{
        &.animating{
          animation: tirol-animation 1s;
          transform-origin: bottom;
        }
        @keyframes tirol-animation {
          20% {
            transform: scale(1, 1.05);
          }
          40% {
            transform: scale(1, 1) translateX(10px);
          }
          60% {
            transform: scale(1, 1.05);
          }
          80% {
            transform: scale(1, 1) translateX(10px);
          }
        }
      }
    }

    .light_balls{
      position: absolute;
      bottom: 170px;
      left: 50%;
      width: 1px;
      height: 1px;
      .ball{
        position: absolute;
        .ball_image{
          opacity: 0;
          width: 30px;
          height: 30px;
          border-radius: 15px;
          background-color: rgba(255,255,255,0.85);
          animation: ball-animation 1.6s;
        }
      }
      .rarity1{
        box-shadow: 0px 0px 10px 3px $rarity1, 0px 0px 15px 2px $rarity1 inset;
      }
      .rarity2{
        box-shadow: 0px 0px 10px 3px $rarity2, 0px 0px 15px 2px $rarity2 inset;
      }
      .rarity3{
        box-shadow: 0px 0px 10px 3px $rarity3, 0px 0px 15px -2px $rarity3 inset;
      }
      .rarity4{
        box-shadow: 0px 0px 10px 3px $rarity4, 0px 0px 15px 2px $rarity4 inset;
      }
      .rarity5{
        box-shadow: 0px 0px 10px 3px $rarity5, 0px 0px 15px 2px $rarity5 inset;
      }

      @keyframes ball-animation{
        0% {
          opacity: 0.2;
          transform: scale(0.5, 0) translateY(10px);
        }
        20% {
          opacity: 1;
          transform: scale(1.1, 1.2) translateY(-5px);
        }
        50% {
          opacity: 1;
          transform: scale(1.2, 1) translateY(2px);
        }
        70% {
          opacity: 1;
          transform: scale(1, 1) translateY(0px);
        }
        100%{
          opacity: 0;
          transform: scale(0.1, 3) translateY(-30px);
        }
      }
    }
    .blight_effects{
      position: absolute;
      bottom: 220px;
      left: 50%;
      width: 1px;
      height: 1px;
      .blight{
        position: absolute;
        .blight_image{
          opacity: 0;
          width: 2px;
          height: 15px;
          border-radius: 2px;
          background-color: rgba(225, 255, 89, 0.85);
          box-shadow: 0px 0px 10px 3px $rarity1, 0px 0px 15px 2px $rarity1 inset;
          animation: blight-animation 0.5s;
        }
      }
      @keyframes blight-animation{
        0% {
          opacity: 0;
          transform: translateY(-20px);
        }
        50% {
          opacity: 1;
        }
        100%{
          opacity: 0;
          transform: translateY(20px);
        }
      }
    }
    .rarity1{
      color: $rarity1;
    }
    .rarity2{
      color: $rarity2;
    }
    .rarity3{
      color: $rarity3;
    }
    .rarity4{
      color: $rarity4;
    }
    .rarity5{
      color: $rarity5;
    }
  }
</style>

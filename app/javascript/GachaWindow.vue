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
      .body
        .pot
          img.pot_image(:src="`/images/gacha/pot${gacha.pot_grade}.png`")
        .rates
          .index
            | - 提供割合 - 
          .table
            .item(v-for="rate in rarityObjects")
              .rarity
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
            | 　- ご利益 -
          .table
            .reward(v-for="reward in gacha.recent_fixed_rewards" :class="reward.point <= estimatedTotal  ? 'available' : ''")
              .total
                | {{reward.point}}
              img.icon(:src="`/images/ui/${reward.giftable_type.toLowerCase()}.png`")
              .cross
                | x
              .amount
                | {{reward.amount}}
        .characters
          img.tirol(src="/images/gacha/tirol.png")
          img.spica(src="/images/gacha/spica.png")
    .gacha_result.full_covered_window(v-if="showingResult")
      .random_results
        .result(v-for="reward in rewards.random_rewards" :class="`rarity${guessRarityFromFirstCharacter(reward)}`")
          | {{reward}}
      .fixed_results
        .index
          | - ご利益 -
        .results
          .result(v-for="reward in rewards.fixed_rewards")
            | {{reward}}
      .done.clickable(@click="showingResult = false")
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
      pool: 0,
      showingResult: false,
      connecting: false,
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
      if(this.connecting){
        console.log("通信中だよ");
        return;
      }
      if(this.pool === 0){
        console.log("空やんけ");
        return;
      }
      this.connecting = true;
      const path = `/gacha.json`;
      const params = {
        amount: this.pool,
      }
      ax.post(path, params)
        .then((results) => {
          console.log(results);
          this.showingResult = true;
          this.rewards = results.data.rewards;
          this.gacha = results.data.gacha;
          this.pool = 0;
          this.connecting = false;
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
          this.connecting = false;
        });      
    },
    calibratePool(){
      this.pool = parseInt(this.pool) || 0;
      this.pool = Math.min(Math.max(this.pool, 0), this.gacha.limit, this.$store.state.user.status.coin);
    },
    resetPool(){
      if(this.connecting){
        console.log("通信中だよ");
        return;
      }
      this.pool = 0;
    },
    addPoolSingle(){
      if(this.connecting){
        console.log("通信中だよ");
        return;
      }
      this.pool += this.gacha.limit / 10;
      this.calibratePool();
    },
    addPoolMax(){
      if(this.connecting){
        console.log("通信中だよ");
        return;
      }
      this.pool = this.gacha.limit;
      this.calibratePool();
    },
    guessRarityFromFirstCharacter(reweardText){
      const raritySymbols = ["", "・", "*", "☆", "★", "◆"];
      return raritySymbols.indexOf(reweardText[0]);
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
    background-color: rgba(0,0,0,0.7);
    opacity: 1;
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
      .result{
        width: 50%;
        line-height: 100%;
        padding: $space;
        font-size: $font-size-large;
        text-align: center;
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
      top: 100px;
      left: 30px;
      width: 200px;
      height: 180px;
      font-size: $font-size-large;
      .index{
        text-align: center;
      }
      .table{
        display: flex;
        flex-direction: column;
        width: 100%;
        height: 100%;
        justify-content: space-around;
        .item{
          border-bottom: 1px solid $gray3;
          width: 100%;
          line-height: 140%;
          .rarity{
            display: inline-block;
            text-align: center;
            width: 20%;
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
      top: 100px;
      right: 30px;
      width: 250px;
      height: 180px;
      .index{
        width: 100%;
        text-align: center;
        font-size: $font-size-large;
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
      top: 100px;
      $width: 420px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 180px;
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
    }
  }
</style>

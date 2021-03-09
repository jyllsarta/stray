<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'gacha', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'gacha', state: false})")
          .arrow
        .title
          | 神秘の鍋
      .description
        | コインを投入して、溢れてくる何かを掴み取りましょう。
      .body
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
        .coins
          .current
            | 99999999
          .to.clickable
            | ↓
          .pool
            | 123456
          .go.clickable
            | 投入！
        .rewards
          .index
            | - ご利益 -
          .table
            .reward
              .total
                | 999999999
              img.icon(src="/images/ui/coin.png")
              .cross
                | x
              .amount
                | 9876543
            .reward
              .total
                | 999999999
              img.icon(src="/images/ui/coin.png")
              .cross
                | x
              .amount
                | 9876543
            .reward
              .total
                | 999999999
              img.icon(src="/images/ui/coin.png")
              .cross
                | x
              .amount
                | 9876543
            .reward
              .total
                | 999999999
              img.icon(src="/images/ui/coin.png")
              .cross
                | x
              .amount
                | 9876543
            .reward
              .total
                | 999999999
              img.icon(src="/images/ui/coin.png")
              .cross
                | x
              .amount
                | 9876543
        .pot
          img.pot_image(:src="`/images/gacha/pot${gacha.pot_grade}.png`")
        .characters
          img.tirol(src="/images/gacha/tirol.png")
          img.spica(src="/images/gacha/spica.png")

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
        pot_grade: 0,
        rates: [0, 8000, 1000, 500, 250, 250],
        recent_fixed_rewards: [],
      }
    };
  },
  props: {
  },
  store,
  mounted(){
    this.fetchGachaIndex();
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
    }
  },
  methods: {
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
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
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
      height: 200px;
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
      right: $space;
      width: 300px;
      height: 250px;
      .index{
        width: 100%;
        text-align: center;
        font-size: $font-size-large;
      }
      .table{
        width: 100%;
        height: 100%;
        line-height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        align-items: flex-end;
        .reward{
          .total{
            display: inline-block;
            width: 6em;
          }
          .icon{
            display: inline-block;
            width: 20px;
            height: 20px;
          }
          .cross{
            display: inline-block;
            width: 1em;
            text-align: center;
          }
          .amount{
            display: inline-block;
            width: auto;
            text-align: right;
          }
          @for $i from 1 through 10 {
            &:nth-child(#{$i}) {
              font-size:#{24 - $i}px;
            }
          }
        }
      }
    }
    .coins{
      position: absolute;
      top: 100px;
      $width: 400px;
      left: calc((100% - #{$width}) / 2);
      width: $width;
      height: 200px;
      display: flex;
      flex-direction: column;
      align-items: center;
      font-size: $font-size-large;
      justify-content: space-between;
      .current{}
      .to{
        padding: $space;
      }
      .pool{}
      .go{
        padding: $space;
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

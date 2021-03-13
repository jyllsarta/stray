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
        .controls
          .line
            .label
              | 所持：
            img.icon(src="/images/ui/coin.png")
            .value
              | {{$store.state.user.status.coin - pool}}
            .buttons
              .button.clickable
                | 戻す
          .line
            .label
              | 投入：
            img.icon(src="/images/ui/coin.png")
            .value
              input.pool_text(v-model="pool" @blur="onPoolBlur()")
            .buttons
              .button.clickable
                | +100
              .button.clickable
                | MAX
          .line
            .label
              | 累計：
            img.icon(src="/images/ui/coin.png")
            .value
              | 123456789
            .buttons
              .button.clickable(@click="doGacha")
                | 投入！
        .rewards
          .index
            | 　- ご利益 -
          .table
            .reward(v-for="reward in gacha.recent_fixed_rewards")
              .total
                | {{reward.point}}
              img.icon(:src="`/images/ui/${reward.giftable_type.toLowerCase()}.png`")
              .cross
                | x
              .amount
                | {{reward.amount}}
        .pot
          img.pot_image(:src="`/images/gacha/pot${gacha.pot_grade}.png`")
        .characters
          img.tirol(src="/images/gacha/tirol.png")
          img.spica(src="/images/gacha/spica.png")
    .gacha_result.full_covered_window(v-if="showingResult")
      .random_results
        .result
          | *あんぱん+55
        .result.rarity2
          | *あんぱん+55
        .result
          | *あんぱん+55
        .result
          | *あんぱん+55
        .result
          | *あんぱん+55
        .result
          | *あんぱん+55
        .result
          | *あんぱん+55
      .fixed_results
        .index
          | - ご利益 -
        .results
          .result
            | コインx7000枚
          .result
            | 星のカケラx5個
          .result
            | 星のカケラx5個
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
        pot_grade: 0,
        rates: [0, 8000, 1000, 500, 250, 250],
        recent_fixed_rewards: [],
      },
      pool: 0,
      showingResult: false,
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
    }
  },
  methods: {
    put(){
      this.pool += 1;
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
      this.showingResult = true;
    },
    onPoolBlur(){
      console.log(this.pool);
      // TODO impl
    }
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
      right: 30px;
      width: 250px;
      height: 300px;
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
          }
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

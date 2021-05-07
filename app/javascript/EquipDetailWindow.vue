<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
          .arrow
        .title
          | 装備詳細
      .current_coin
        .icon
          img(src="/images/ui/coin.png")
        .amount
          | {{$store.state.user.status.coin}}
      .description
        | {{item.name}}の詳細画面です。コインを消費して、強化上限値(+{{$store.state.user.status.max_item_rank_for_rankup}})まで強化できます。
      .body
        .status_area
          .before.parameter_box
            .name
              | {{$store.getters['equip_window/getItemRarityIcon'](item_id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item_id)}}
            .total.item
              .label
                |  TOTAL
              .value
                | {{item.effectValue}}
            .item(v-for="param in ['str', 'dex', 'vit', 'agi']")
              .label(:class="param")
                |  {{param.toUpperCase()}}
              .value
                | {{getEffectValue(item, param)}}
            .item
              .label.power
                | 力
              .value
                | {{item.power()}}
            .item
              .label.tech
                | 技
              .value
                | {{item.tech()}}
          .after.parameter_box(:style="{opacity: canRankUp() ? 1 : 0.3}")
            .name
              | {{$store.getters['equip_window/getItemRarityIcon'](item_id)}}{{item.name}}+{{item.rank + parsedCount}}
            .total.item
              .label
                |  TOTAL
              .value
                | {{ rankUpItemEffectValue() }}
              .diff(:class="diffClass(rankUpItemEffectValue() - item.effectValue)")
                | ({{diffText(rankUpItemEffectValue() - item.effectValue)}})
            .item(v-for="param in ['str', 'dex', 'vit', 'agi']")
              .label(:class="param")
                |  {{param.toUpperCase()}}
              .value
                | {{ item.effectValueOf(param, parsedCount) }}
              .diff(:class="diffClass(item.effectValueOf(param, parsedCount) - item.effectValueOf(param))")
                | ({{diffText(item.effectValueOf(param, parsedCount) - item.effectValueOf(param))}})
            .item
              .label.power
                | 力
              .value
                | {{item.power(parsedCount)}}
              .diff(:class="diffClass(item.power(parsedCount) - item.power())")
                | ({{diffText(item.power(parsedCount) - item.power())}})
            .item
              .label.tech
                | 技
              .value
                | {{item.tech(parsedCount)}}
              .diff(:class="diffClass(item.tech(parsedCount) - item.tech())")
                | ({{diffText(item.tech(parsedCount) - item.tech())}})
        .cannot_rankup(v-if="!canRankUp()")
          | {{cannotRankUpReason()}}
        .slider_area
          .labels
            .min.label
              | +{{ item.rank }}
            .current.label(:class="[canRankUp() ? '' : 'cannot']")
              | +{{item.rank + parsedCount}}
            .max.label
              | +{{Math.max(item.rank + rankUpLimit, item.rank + parsedCount)}}
          .slider
            input(type="range" orient="vertical" v-model="count" min="0" :max="rankUpLimit")
        .controls
          .costs
            .line
              .label
                | 所持
              .coin_icon
              .value(:class="[isCoinSufficient() ? '' : 'insufficient_coin']")
                | {{$store.state.user.status.coin}}
            .line
              .label
                | 消費
              .coin_icon
              .value
                | {{totalRankUpCost(parsedCount)}}
          .rank_up(@click="executeRankUpItem", :class="canRankUp() ? 'super_clickable' : 'not_clickable'")
            | 強化
        .enchantment_area

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      item_id: null,
      count: 1,
      rankUpLimit: 0,
      defaultItemObject: {
        effectValueOf(){},
        power(){},
        tech(){},
      }
    };
  },
  props: {
  },
  store,
  mounted(){
    this.item_id = this.$store.state.equip_window.selecting_item_id || 1;
    this.calculateRankUpLimit();
  },
  computed: {
    item(){
      return this.$store.state.equip_window.user_items[this.item_id] || this.defaultItemObject;
    },
    parsedCount(){
      return parseInt(this.count);
    }
  },
  methods: {
    rankUpItemEffectValue(){
      return ['str', 'dex', 'vit', 'agi'].reduce((p,x)=>(p + this.item.effectValueOf(x, this.parsedCount)), 0);
    },
    getEffectValue(itemObj, param){
      if(!itemObj.effectValueOf){
        return 0;
      }
      return itemObj.effectValueOf(param);
    },
    diffText(diff){
      if(diff === 0){
        return diff;
      }
      if(diff > 0){
        return "+" + diff;
      }
      // マイナスは元々付いてるので文字列化するだけで良し
      return "" + diff;
    },
    diffClass(diff){
      if(diff === 0){
        return "";
      }
      if(diff > 0){
        return "plus";
      }
      return "minus";
    },
    executeRankUpItem(){
      if(!this.canRankUp()){
        console.log("強化不能ですね");
        return;
      }
      this.$store.dispatch("user/rankUpItem", {item_id: this.item_id, count: this.count} ).then(()=>{
        this.$store.commit("equip_window/updateUserItemRank", {item_id: this.item_id, rank: this.item.rank + this.parsedCount})
        this.count = 1;
        this.calculateRankUpLimit();
      });
    },
    calculateRankUpLimit(){
      const coin = this.$store.state.user.status.coin;
      let i = 0;
      let cost = 0;
      while(coin >= cost){
        cost += this.rankUpCost(this.item.rank + this.item.base_rank + i)
        i++;
      }
      let coinLimit = i - 1;
      let rankLimit = this.maxRank() - this.item.rank || 1;
      this.rankUpLimit = Math.min(coinLimit, rankLimit);
    },
    totalRankUpCost(delta){
      const rank = (this.item.rank + this.item.base_rank) || 0;
      let totalCost = 0;
      for(let i = 0; i < delta; i++){
        totalCost += this.rankUpCost(rank + i);
      }
      return totalCost;
    },
    rankUpCost(rank){
      return Math.min(
        Math.floor((Math.pow(rank , 2) * this.$store.getters['user/rarityFactor'](this.item.rarity)) / 100 + 100),
        Constants.item.maxRankUpCost,
      );
    },
    canRankUp(){
      return this.isCoinSufficient() && this.isRankCapable();
    },
    cannotRankUpReason(){
      let reason = "";
      if(!this.isCoinSufficient()){
        reason += "コイン不足です。"
      }
      if(!this.isRankCapable()){
        reason += "最大強化ランクに達しました。"
      }
      return reason;
    },
    isCoinSufficient(){
      return this.totalRankUpCost(this.count) <= this.$store.state.user.status.coin;
    },
    isRankCapable(){
      return this.item.rank < this.maxRank();
    },
    maxRank(){
      return this.$store.state.user.status.max_item_rank_for_rankup;
    }
  },
  watch: {
    "$store.state.user.status.coin": {
      handler: function (events) {
        this.calculateRankUpLimit();
      }
    }
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
.current_coin{
  position: absolute;
  top: $space;
  right: $space;
  display: flex;
  .icon{
    img{
      width: 32px;
    }
  }
  .amount{
    line-height: 32px;
    font-size: $font-size-large;
  }
}
.body{
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  padding: $space;
  width: 100%;
  height: 500px;
  .status_area{
    height: 280px;
    padding: $space;
    display: flex;
    justify-content: center;
    font-size: 18px; // ここは特異なフォントサイズにします。なんかどうしてもlargeだと大きくてnormalだと小さい...
    .parameter_box{
      padding: $space;
      width: 400px;
      height: 100%;
      display: flex;
      flex-direction: column;
      justify-content: space-around;
      .item{
        width: 100%;
        .label{
          padding-left: 6rem;
          width: 10rem;
          padding-right: $space;
          text-align: right;
          display: inline-block;
          line-height: 100%;
        }
        .value{
          width: 7rem;
          display: inline-block;
          text-align: right;
        }
        .diff{
          width: 6rem;
          display: inline-block;
          padding-left: $space;
        }
      }
      .name{
        text-align: center;
      }
      .str{
        color: $str;
      }
      .dex{
        color: $dex;
      }
      .vit{
        color: $vit;
      }
      .agi{
        color: $agi;
      }
      .plus{
        color: $plus;
      }
      .minus{
        color: $minus;
      }
      .power{
        color: $plus;
      }
      .tech{
        color: $minus;
      }
    }
    .before{
      border-right: 1px solid $gray3;
    }
  }
  .slider_area{
    padding-top: $space;
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 100%;
    .labels{
      width: 500px;
      display: flex;
      justify-content: space-between;
      .cannot{
        color: $plus;
      }
      .label{
        width: 4rem;
        text-align: center;
      }
    }
    .slider{
      background-color: #93baeb;
      width: 440px;
      height: 30px;
      border-radius: $radius;
      input{
        -webkit-appearance:none;
        width: 100%;
        height: 100%;
        background: linear-gradient(to right, $gray3, transparent );
        border-radius: $radius;
        outline: none;
      }
      input[type=range]::-webkit-slider-thumb {
        -webkit-appearance: none;
        border-radius: $radius;
        background-color: $white;
        height: 100%;
        width: 10px;
      }
    }
  }
  .controls{
    height: 60px;
    padding: $space;
    display: flex;
    justify-content: center;
    .costs{
      width: 200px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      .line{
        display: flex;
        align-items: flex-end;
        line-height: 100%;
        div{
          display: inline-block;
        }
        .coin_icon{
          width: 20px;
          height: 20px;
          display: inline-block;
          background-image: url("/images/ui/coin.png");
          background-size: cover;
        }
        .value{
          text-align: right;
          width: 6rem;
        }
        .insufficient_coin{
          color: $plus;
        }
      }
    }
    .rank_up{
      width: 100px;
      height: 100%;
      line-height: 100%;
      padding-top: 14px; // ここなぜか計算が合わないのでベタ指定にします
      text-align: center;
    }
  }
  .enchantment_area{
    border-top: 1px solid $gray3;
    height: 100px;
    padding: $space;
  }
}
.cannot_rankup{
  position: absolute;
  bottom: 200px;
  right: 80px;
  width: 400px;
  text-align: center;
}

</style>

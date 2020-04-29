<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: false})")
        .title
          | 装備詳細
      .current_coin
        .icon
          img(src="/images/ui/coin.png")
        .amount
          | {{$store.state.user.status.coin}}
      .description
        | {{item().name}}の詳細画面です。コインを消費して、所持しているアイテムの最大強化値(+{{$store.getters['user/maxItemRank']}})まで強化できます。
      .body
        .status_area
          .before.parameter_box
            .name
              | {{$store.getters['equip_window/getItemRarityIcon'](item_id)}}{{item().name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item_id)}}
            .total.item
              .label
                |  TOTAL
              .value
                | {{item().effectValue}}
            .item(v-for="param in ['str', 'dex', 'def', 'agi']" :class="param")
              .label
                |  {{param.toUpperCase()}}
              .value
                | {{getEffectValue(item(), param)}}
          .after.parameter_box
            .name
              | {{$store.getters['equip_window/getItemRarityIcon'](item_id)}}{{item().name}}+{{item().rank + 1}}
            .total.item
              .label
                |  TOTAL
              .value
                | {{rankUpItem().effectValue}}
                .diff
                  | ({{rankUpItem().effectValue - item().effectValue}})
            .item(v-for="param in ['str', 'dex', 'def', 'agi']" :class="param")
              .label
                |  {{param.toUpperCase()}}
              .value
                | {{getEffectValue(rankUpItem(), param)}}
                .diff
                  | ({{diffText(getEffectValue(rankUpItem(), param) - getEffectValue(item(), param))}})

        .controls
          .costs
            .line
              .label
                | 所持
              .coin_icon
              .value
                | 123123123
            .line
              .label
                | 消費
              .coin_icon
              .value
                | 98287
          .rank_up.clickable
            | 強化
        .enchantment_area
          //ここは実装後に埋めればいいや


</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      item_id: 5,
    };
  },
  props: {
  },
  store,
  mounted(){
  },
  computed: {
  },
  methods: {
    item(){
      return this.$store.getters['equip_window/getUserItem'](this.item_id) || {};
    },
    rankUpItem(){
      return this.$store.getters['equip_window/getUserItem'](this.item_id, 1) || {};
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
      return "-" + diff;
    },
  },
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
  height: 440px;
  .status_area{
    height: 230px;
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
          width: 45%;
          padding-right: $space;
          text-align: right;
          display: inline-block;
        }
        .value{
          width: 55%;
          display: inline-block;
          .diff{
            display: inline-block;
            padding-left: $space;
          }
        }
      }
      .name{
        text-align: center;
      }
    }
    .before{
      border-right: 1px solid $gray3;
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

</style>

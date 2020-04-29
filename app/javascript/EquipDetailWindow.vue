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
        | #########の詳細画面です。コインを消費して、所持しているアイテムの最大強化値(+77315)まで強化できます。
      .body
        .status_area
          .before.parameter_box
            .name
              | ◆伝説のリズムカーニバル+765983
            .total.item
              .label
                |  TOTAL
              .value
                | 123123123
            .str.item
              .label
                |  STR
              .value
                | 123123123
            .dex.item
              .label
                |  DEX
              .value
                | 123123123
            .def.item
              .label
                |  DEF
              .value
                | 123123123
            .agi.item
              .label
                |  AGI
              .value
                | 123123123
          .after.parameter_box
            .name
              | ◆伝説のリズムカーニバル+765984
            .total.item
              .label
                |  TOTAL
              .value
                | 123123123
                .diff
                  | (+82828282)
            .str.item
              .label
                |  STR
              .value
                | 123123123
                .diff
                  | (+82828282)
            .dex.item
              .label
                |  DEX
              .value
                | 123123123
                .diff
                  | (+82828282)
            .def.item
              .label
                |  DEF
              .value
                | 123123123
                .diff
                  | (+82828282)
            .agi.item
              .label
                |  AGI
              .value
                | 123123123
                .diff
                  | (+82828282)
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

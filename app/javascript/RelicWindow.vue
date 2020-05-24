<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'relic', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'relic', state: false})")
        .title
          | 能力解放
      .description
        | 星のカケラを使って、新しい能力を解放します。
      .body
        .field
          .relics
            .relic(
              v-for="relic in $store.state.masterdata.relics"
              :class="[`relic_${relic.id}`, relicStatus(relic.id)]"
              @click="selectRelic(relic.id)"
              )
        .detail
          .relic_detail
            .title
              .icon
              .name
                | {{selectingRelic.name}}
            .desc
              | {{selectingRelic.description}}
          .star
            .line
              .label
                | 所持
              .icon
              .value
                | {{$store.state.user.status.star}}
            .line
              .label
                | 消費
              .icon
              .value
                | {{selectingRelic.cost}}
          .button
            .get(:class="[relicStatus(selectingRelicId), (relicStatus(selectingRelicId) === 'available') ? 'clickable' : '']")
              | {{relicLabels[relicStatus(selectingRelicId)]}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      selectingRelicId: 1,
      relicLabels: {
        disabled: "取得不可",
        got: "取得済み",
        available: "取得",
      }
    };
  },
  props: {
  },
  store,
  mounted(){
  },
  computed: {
    selectingRelic(){
      return this.$store.state.masterdata.relics[this.selectingRelicId] || {};
    }
  },
  methods: {
    relic(id){
      return this.$store.state.masterdata.relics[id] || {};
    },
    selectRelic(id){
      this.selectingRelicId = id;
      console.log(id);
    },
    relicStatus(relicId){
      const relic = this.relic(relicId);
      // 取得済みなら got
      if(this.$store.state.user.relics[relicId]){
        return "got";
      }
      // コストが足りないなら disabled
      if(this.$store.state.user.status.star < relic.cost){
        return "disabled";
      }
      // 親の取得がまだなら disabled
      if(relic.parent_relic_id && !this.$store.state.user.relics[relic.parent_relic_id]){
        return "disabled";
      }
      // 取得可能なら available
      return "available";
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
.body{
  .field{
    height: 300px;
    width: 100%;
    border-bottom: 1px solid $gray3;
    .relics{
      position: absolute;
      .relic{
        position: absolute;
        width: 48px;
        height: 48px;
        background-color: #323749;
        &:hover{
          filter: brightness(130%);
        }
      }
    }
  }
  .detail{
    padding-top: $space;
    height: 140px;
    width: 100%;
    display: flex;
    .relic_detail{
      padding-right: $space;
      width: 60%;
      .title{
        display: flex;
        width: 100%;
        height: 50px;
        align-items: flex-end;
        border-bottom: 1px solid $gray3;
        .icon{
          width: 48px;
          height: 48px;
          background-color: #747487;
        }
        .name{
          padding-left: $space;
          font-size: $font-size-large;
        }
      }
      .desc{
        padding: $thin_space;
      }
    }
    .star{
      width: 20%;
      padding: 20px 0 20px 0;
      display: flex;
      flex-direction: column;
      justify-content: space-around;
      font-size: $font-size-large;
      line-height: 100%;
      .line{
        display: flex;
        align-items: flex-end;
        line-height: 100%;
        div{
          display: inline-block;
        }
        .icon{
          margin-left: $space;
          width: 22px;
          height: 22px;
          display: inline-block;
          background-image: url("/images/ui/star.png");
          background-size: cover;
        }
        .value{
          text-align: right;
          width: 6rem;
        }
      }
    }
    .button{
      width: 20%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      .get{
        font-size: $font-size-large;
        line-height: 100%;
        padding-top: (50px - $font-size-large) / 2;
        border-radius: $radius;
        width: 130px;
        height: 50px;
        text-align: center;
      }
    }
  }

  // ボタンとレリック共通で使うのでブロック外で定義
  .available{
    border: 1px solid $gray1;
  }
  .disabled{
    border: 1px solid $gray2;
    opacity: 0.6;
    &:hover{
      filter: brightness(100%);
    }
  }
  .got{
    border: 1px solid $yellow;
  }
}


// 各レリックの場所定義
// 置き方を私が決めたいので、flexではなく全部absoluteでゴリ押す
.relic_1{
  top: 30px;
  left: 30px;
}
.relic_2{
  top: 120px;
  left: 30px;
}
.relic_3{
  top: 210px;
  left: 30px;
}
.relic_4{
  top: 30px;
  left: 130px;
}
.relic_5{
  top: 120px;
  left: 130px;
}
.relic_6{
  top: 30px;
  left: 230px;
}
.relic_7{
  top:120px;
  left: 230px;
}

</style>

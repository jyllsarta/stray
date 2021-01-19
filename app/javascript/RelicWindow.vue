<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'relic', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'relic', state: false})")
          .arrow
        .title
          | 能力解放
      .description
        | 星のカケラを使って、新しい能力を解放します。
      .body
        .field
          .relics
            .relic.selectable(
              v-for="relic in $store.state.masterdata.relics"
              :class="[`relic_${relic.id}`, relicStatus(relic.id), obtainRelicClass(relic.id), selectingRelicClass(relic.id)]"
              @click="selectRelic(relic.id)"
              )
              img.icon(:src="`/images/icons/relic/${relic.id}.gif`")
        .detail
          .relic_detail
            .title
              transition(name="show-in")
                img.icon(:src="`/images/icons/relic/${selectingRelic.id || 'nothing'}.gif`" :key="selectingRelic.id")
              .relic_name(:key="selectingRelic.name")
                | {{selectingRelic.name}}
            .parent
              .descri
                | 前提：
              img.icon(:src="`/images/icons/relic/${selectingRelicParent.id || 'nothing'}.gif`")
              .relic_name(:key="selectingRelicParent.name", :class="parentRelicObtained ? '' : 'red'")
                | {{selectingRelicParent.name || 'なし'}}
            .desc
              span.letter(
                v-for="(t, index) in selectingRelic.description"
                :key="selectingRelic.id + t + index"
                :style="{animationDelay: (150 + index*3)+'ms'}"
                v-text="t")
          .star
            .line
              .label
                | 所持
              .icon
              .value
                NumeratableNumber(:number="$store.state.user.status.star")
            .line
              .label
                | 消費
              .icon
              .value(:class="hasSufficientStar ? '' : 'red'")
                NumeratableNumber(:number="selectingRelic.cost || 0" :speed="0.2")
          .button
            .get(
              :class="[relicStatus(selectingRelicId), (relicStatus(selectingRelicId) === 'available') ? 'clickable' : '']"
              @click="obtainRelic(selectingRelicId)"
              )
              | {{relicLabels[relicStatus(selectingRelicId)]}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import NumeratableNumber from "./NumeratableNumber.vue";

export default {
  components: {
    NumeratableNumber
  },

  data: function () {
    return {
      selectingRelicId: null,
      relicLabels: {
        disabled: "取得不可",
        got: "取得済み",
        available: "取得",
      },
      nowRequesting: false,
      obtainEffectRelicId: 0,
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
    },
    selectingRelicParent(){
      return this.$store.state.masterdata.relics[this.selectingRelic.parent_relic_id] || {};
    },
    parentRelicObtained(){
      if(this.selectingRelicParent.id === undefined){
        return true;
      }
      return !!this.$store.state.user?.relics[this.selectingRelicParent.id];
    },
    hasSufficientStar(){
      return this.$store.state.user?.status?.star >= (this.selectingRelic.cost || 0);
    },
  },
  methods: {
    relic(id){
      return this.$store.state.masterdata.relics[id] || {};
    },
    selectRelic(id){
      this.selectingRelicId = id;
    },
    relicStatus(relicId){
      const relic = this.relic(relicId);
      // データ未取得なら disabled
      if(!relicId){
        return "disabled";
      }
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
    },
    obtainRelic(relicId){
      if(this.relicStatus(relicId) !== "available" || this.nowRequesting){
        console.log("取得可能レリックでないのでスルーします");
        return;
      }
      this.nowRequesting = true;
      this.$store.dispatch("user/obtainRelic", relicId)
        .then(()=>{
            this.nowRequesting = false;
            this.obtainEffectRelicId = relicId;
            this.$store.dispatch("user/fetchUserModel");
            this.$store.commit("event/addEventLog", {message: `${this.relic(relicId).name}を取得した！`});
          }
        );
    },
    obtainRelicClass(relicId){
      return relicId === this.obtainEffectRelicId ? "obtained" : "";
    },
    selectingRelicClass(relicId){
      return relicId === this.selectingRelicId ? "selecting" : "";
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
        width: 50px;
        height: 50px;
        background-color: #323749;
        &:hover{
          filter: brightness(150%);
        }
        .icon{
          width: 48px;
          height: 48px;
          image-rendering: pixelated;
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
      .title {
        display: flex;
        width: 100%;
        height: 50px;
        align-items: flex-end;
        border-bottom: 1px solid $gray3;

        .icon {
          width: 48px;
          height: 48px;
          image-rendering: pixelated;
        }

        .relic_name {
          padding-left: $space;
          font-size: $font-size-large;
        }
      }
      .parent{
        display: flex;
        width: 100%;
        height: 24px;
        align-items: flex-end;
        border-bottom: 1px solid $gray3;
        .descri{
          width: 3rem;
        }
        .icon{
          width: 24px;
          height: 24px;
          image-rendering: pixelated;
        }
        .relic_name{
          padding-left: $space;
          font-size: $font-size-normal;
        }
      }
      .red{
        color: $plus;
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
        justify-content: flex-end;
        align-items: center;
        line-height: 100%;
        height: 30px;
        div{
          display: inline-block;
        }
        .label{
          font-size: $font-size-normal;
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
        .red{
          color: $plus;
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
  .selecting{
    filter: brightness(150%);
  }
}


// 各レリックの場所定義
// 置き方を自由に決めたいので、flexではなく全部absoluteでゴリ押す

// イベント短縮
.relic_31{
  top:   20px;
  left:  20px;
}
.relic_32{
  top:   80px;
  left:  20px;
}
.relic_33{
  top:  140px;
  left:  20px;
}

.relic_11{
  top:  100px;
  left: 100px;
}

.relic_12{
  top:  180px;
  left: 100px;
}

.relic_21{
  top:  100px;
  left: 320px;
}

.relic_22{
  top:  180px;
  left: 320px;
}

// HPレリック

.relic_41{
  top:   20px;
  left: 540px;
}

.relic_42{
  top:   74px;
  left: 540px;
}

.relic_43{
  top:  128px;
  left: 540px;
}

.relic_44{
  top:  182px;
  left: 540px;
}

.relic_45{
  top:  236px;
  left: 540px;
}

.relic_98{
  top:  182px;
  left: 600px;
}

.relic_99{
  top:  236px;
  left: 600px;
}

// スピカスキル
.relic_101{
  top:   20px;
  left: 170px;
}
.relic_102{
  top:   20px;
  left: 240px;
}
.relic_103{
  top:  100px;
  left: 170px;
}
.relic_104{
  top:  100px;
  left: 240px;
}
.relic_105{
  top:  180px;
  left: 170px;
}
.relic_106{
  top:  180px;
  left: 240px;
}

// チロルスキル
.relic_201{
  top:   20px;
  left: 390px;
}
.relic_202{
  top:   20px;
  left: 460px;
}
.relic_203{
  top:  100px;
  left: 390px;
}
.relic_204{
  top:  100px;
  left: 460px;
}
.relic_205{
  top:  180px;
  left: 390px;
}
.relic_206{
  top:  180px;
  left: 460px;
}



@keyframes vertical-text-in {
  0% {
    transform: translate(0, -2px);
    opacity: 0;
  }
}
@keyframes horizontal-text-in {
  0% {
    transform: translate(-20px, 0);
    opacity: 0;
  }
}
@keyframes main-image {
  0% {
    background-position: 0 0;
    opacity: 0.5;
  }
}

@keyframes obtained {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  91% {
    transform: scale(4) rotate(5deg);
    opacity: 0;
  }
  92%{
    transform: scale(0) rotate(-5deg);
    opacity: 0;
  }
  100%{
    transform: scale(1);
    opacity: 1;
  }
}

.relic_name {
  min-width: 0.3em;
  animation: horizontal-text-in .3s cubic-bezier(0,.71,.17,.95) 0s;
}
.letter {
  display: inline-block;
  min-width: 0.3em;
  font-size: $font-size-mini;
  animation: vertical-text-in .3s cubic-bezier(0.22, 0.15, 0.25, 1.43) 0s backwards;
}

.obtained{
  animation: obtained 1.3s cubic-bezier(0.22, 0.15, 0.25, 1.43) 0s backwards;
}

.show-in-enter-active {
  transition: all .3s;
}
.show-in-leave-active {
  transition: all .3s;
}
.show-in-enter{
  position: absolute;
  transform: translateY(-10px);
  opacity: 0;
}
.show-in-leave-to{
  position: absolute;
  transform: translateY(10px);
  opacity: 0;
}

</style>

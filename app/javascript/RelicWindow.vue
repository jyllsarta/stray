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
          .tabs
            .tab.selectable(:class="currentPage===1 ? 'selected' : ''", @click="switchPage(1)")
              | スピカのスキル
            .tab.selectable(:class="currentPage===2 ? 'selected' : ''", @click="switchPage(2)")
              | チロルのスキル
            .tab.selectable(:class="currentPage===3 ? 'selected' : ''", @click="switchPage(3)")
              | なんでもスキル
            .tab.selectable(:class="currentPage===4 ? 'selected' : ''", @click="switchPage(4)" v-if="showsUltimateSkill")
              | きゅうきょくスキル
          .cussion
          .relics
            .obtain_animation(
                v-for="relic in displayRelics"
                :class="obtainRelicClass(relic.id)"
                @click="selectRelic(relic.id)"
                :style="relicStyle(relic)"
                :key="relic.id"
            )
              .relic.selectable(
                :class="[`relic_${relic.id}`,relicStatus(relic.id), selectingRelicClass(relic.id)]"
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
                NumeratableNumber(:number="selectingRelic.cost || 0" :speed="0.4")
          .button
            .get(
              :class="[relicStatus(selectingRelicId), (relicStatus(selectingRelicId) === 'available') ? 'super_clickable' : '']"
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
      currentPage: 1,
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
    this.switchPage(1);
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
    displayRelics(){
      return Object.values(this.$store.state.masterdata.relics).filter(relic=>relic.page===this.currentPage);
    },
    showsUltimateSkill(){
      if(!this.$store.state.user?.dungeon_progresses){
        return false;
      }
      return this.$store.state.user.dungeon_progresses[Constants.dungeon.lastDungeonId]?.max_depth || 0 > 0;
    }
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
      return relicId === this.selectingRelicId ? "selected" : "";
    },
    relicStyle(relic){
      return {
        left: 8 + (relic.grid_x - 1) * 58,
        top: 8 + (relic.grid_y - 1) * 58,
      }
    },
    selectDefaultRelic(){
      this.selectingRelicId = Object.values(this.$store.state.masterdata.relics)
                                    .filter(relic=>relic.page===this.currentPage)
                                    .sort((a,b)=>{return (a.grid_x - b.grid_x) * 100000 + (a.grid_y - b.grid_y)})[0].id;
    },
    switchPage(toPage){
      this.currentPage = toPage;
      this.selectDefaultRelic();
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
    display: flex;
    .tabs{
      width: 200px;
      height: 100%;
      padding: $space;
      display: flex;
      flex-direction: column;
      justify-content: center;
      .tab{
        width: 100%;
        height: 100px;
        margin: $space;
        @include centering($height: 50px);
      }
    }
    .cussion{
      width: 90px;
    }
    .relics{
      position: relative;
      margin-left: (58 * 2)px;
      .obtain_animation{
        position: absolute;
        width: 50px;
        height: 50px;
        .relic{
          width: 50px;
          height: 50px;
          background-color: #323749;
          animation: relic-show-in 0.3s;
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
  .got{
    border: 1px solid $yellow;
  }
  .selected{
    border: 1px solid $yellow;
  }
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

@keyframes relic-show-in {
  0% {
    transform: translate(0, -5px) scale(0.5);
    opacity: 0;
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

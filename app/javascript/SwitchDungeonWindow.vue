<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: false})")
          .arrow
        .title
          | ダンジョン切り替え
      .description
        | 行ったことのあるダンジョンに戻ったり、新しいダンジョンに挑めます。新ダンジョンはクエストの★ボスを倒すと現れます。
      .body
        .dungeon_list_tab.scrollable
          .dungeon.hoverable.selectable(
            v-for="dungeon in visibleDungeons"
            @click="selectDungeon(dungeon.id)"
            :class="dungeonClass(dungeon.id)"
            )
            .name
              | {{dungeon.name}}
            .progress
              .current_progress(:class="floorColorClass(dungeon.id)")
                | {{dungeonProgress(dungeon.id)}}
              |  / {{dungeon.depth}}F
        .control_tab
          .main_image(:style="{backgroundImage: `url('images/backgrounds/${selectingDungeonId}/cateneted.png')`}" :key="selectingDungeonId")
          .controls.window
            .depth_slider
              input(type="range" v-model="selectingDungeonDepth" min="1" :max="currentDungeonMaxDepthCanSwitch" :style="{width: sliderWidthPercent}")
            .go.button.clickable(@click="gotoDungeon")
              | Go!
            .go_to_floor
              input.floor(v-model="selectingDungeonDepth" @blur="onFloorBlur()")
              .f
                | F
            .go_to_floor_label
              | 移動先：
            .returns_on_death.clickable(@click="switchReturnsOnDeath")
              | {{returnsOnDeathText}}
            .returns_on_death_label
              | 全滅したら100F戻る：
            .top_floor
              NumeratableNumber(:number="currentDungeonMaxDepth", :speed="0.4")
              .f
                | F
            .deepest_floor
              | 1F
            .descriptions
              .dungeon_title(:key="selectingDungeon.name")
                | {{selectingDungeon.name}}
              .description
                span.letter(
                  v-for="(t, index) in selectingDungeon.description"
                  :key="t + index"
                  :style="{animationDelay: (200 + index*2)+'ms'}"
                  v-text="t")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import NumeratableNumber from "./NumeratableNumber.vue";

export default {
  data: function () {
    return {
      selectingDungeonId: 0,
      selectingDungeonDepth: 1,
    };
  },
  props: {
    rootRef: Object,
  },
  components: {
    NumeratableNumber,
  },
  store,
  mounted(){
    this.selectDungeon(this.$store.state.user.status.current_dungeon_id);
    this.selectingDungeonDepth = this.$store.state?.user?.status?.current_dungeon_depth || 1;
  },
  computed: {
    visibleDungeons(){
      return this.dungeons.filter((x)=>this.canSwitchDungeon(x.id))
    },
    dungeons(){
      const dungeons = Object.values(this.$store.state.masterdata.dungeons);
      return dungeons;
    },
    selectingDungeon(){
      return this.$store.state.masterdata.dungeons[this.selectingDungeonId] || {};
    },
    currentDungeonMaxDepth(){
      return Math.max(this.selectingDungeon.depth || 0, this.$store.state.user.dungeon_progresses[this.selectingDungeonId]?.max_depth || 0)
    },
    currentDungeonMaxDepthCanSwitch(){
      return this.$store.state.user.dungeon_progresses[this.selectingDungeonId]?.max_depth || 0;
    },
    sliderWidthPercent(){
      const ratio = Math.max(Math.min(this.$store.state.user.dungeon_progresses[this.selectingDungeonId]?.max_depth / this.selectingDungeon.depth, 1), 0.23);
      return Math.floor(ratio * 100) + "%";
    },
    returnsOnDeathText(){
      return this.$store.state.user.status.returns_on_death ? "有効" : "無効";
    }
  },
  methods: {
    selectDungeon(dungeonId){
      this.selectingDungeonId = dungeonId;
      this.selectingDungeonDepth = this.dungeonProgress(dungeonId);
    },
    dungeonProgress(dungeonId){
      return this.$store.state.user.dungeon_progresses[dungeonId]?.max_depth || 1;
    },
    floorColorClass(dungeonId){
      const progress = this.dungeonProgress(dungeonId);
      const max_depth = this.$store.state.masterdata.dungeons[dungeonId]?.depth || 1;
      if(progress >= max_depth){
        return "over_floor";
      }
      return "";
    },
    dungeonClass(dungeonId){
      if(dungeonId == this.selectingDungeonId){
        return "selected";
      }
      return "not_selected";
    },
    canSwitchDungeon(dungeonId){
      // 「親ダンジョンをクリアしている」が表示条件
      const dungeon = this.$store.state.masterdata?.dungeons[dungeonId];
      if(!dungeon){
        return false;
      }
      if(!dungeon.parent_dungeon_id) {
        return true;
      }
      return this.$store.state.user.dungeon_progresses[dungeon.parent_dungeon_id]?.cleared;
    },
    gotoDungeon(){
      this.$store.dispatch("user/gotoDungeon", {dungeon_id: this.selectingDungeonId, depth: this.selectingDungeonDepth})
        .then(()=>{
          this.rootRef.field.reseedScene();
          this.$store.commit('window/updateWindowShowState', {windowName: 'switch_dungeon', state: false})
        })
        .then(()=>{
          // とてもとてもダサいのだけど、一定時間待って十分に演出が流れてから背景を更新する
          // うまくかけていたなら「閉じる」「更新を待つ」「開く」ってできるんだろうけどそれを想定したコードにできなかった...勉強のためにもいつか直したい
          return new Promise((resolve, reject) => {
            setTimeout(resolve, 150);
          });
        })
        .then(()=>{
          this.$store.dispatch("user/fetchUserModel");
          this.$store.commit("event/addEventLog", {message: `${this.$store.state.masterdata.dungeons[this.selectingDungeonId].name}に移動した！`});
        }
      );
    },
    switchReturnsOnDeath(){
      this.$store.dispatch("user/switchReturnsOnDeath", {returns_on_death: !this.$store.state.user.status.returns_on_death});
    },
    onFloorBlur(){
      this.selectingDungeonDepth = parseInt(this.selectingDungeonDepth) || 1;
      this.selectingDungeonDepth = Math.min(Math.max(this.selectingDungeonDepth, 1), this.currentDungeonMaxDepthCanSwitch);
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
    display: flex;
  }
  .dungeon_list_tab{
    margin: $thin_space;
    display: flex;
    flex-direction: column;
    height: 430px;
    width: 380px;
    .dungeon{
      margin: $thin_space;
      padding: $space;
      width: calc(100% - 10px);
      .name{
        display: inline-block;
        width: 60%;
      }
      .progress{
        .current_progress{
          display: inline-block;
        }
        .over_floor{
          color: $yellow;
        }
        display: inline-block;
        width: 40%;
        text-align: right;
      }
    }
  }
  .control_tab{
    .main_image{
      padding: $space;
      width: 600px;
      height: 200px;
      background-repeat: no-repeat;
      background-size: cover;
      background-position: -120px 0;
      image-rendering: pixelated;
    }
    .controls{
      margin-top: $space;
      position: relative;
      height: 232px;
      .depth_slider{
        position: absolute;
        bottom: 0px;
        left: 70px;
        width: 210px;
        height: 20px;
        transform-origin: left;
        transform: rotate(-90deg);
        input{
          -webkit-appearance:none;
          width: 100%;
          height: 100%;
          background: linear-gradient(to right, transparent, $gray3);
          outline: none;
        }
        input[type=range]::-webkit-slider-thumb{
          -webkit-appearance:none;
          border-radius: $radius;
          border-right: 1px solid $gray2;
          border-left: 1px solid $gray2;
          background-color: $gray3-opacity;
          background-image: url("/images/ui/direction_tirol.png");
          background-size: contain;
          background-repeat: no-repeat;
          background-position: top;
          height: 120px;
          width: 45px;
        }
        input[type=range]::-moz-range-thumb{
          -webkit-appearance: slider-vertical;
          border-radius: $radius;
          height: 15px;
          width: 15px;
        }
      }
      .go{
        position: absolute;
        bottom: $space;
        right: $space;
        width: 100px;
        height: 54px;
        line-height: 100%;
        font-size: $font-size-large;
        text-align: center;
        padding-top: (54px - $font-size-large) / 2;
      }
      .go_to_floor{
        position: absolute;
        bottom: $space;
        right: 120px;
        font-size: $font-size-large;
        display: flex;
        .floor{
          color: $white;
          width: 110px;
          text-align: right;
        }
      }
      .go_to_floor_label{
        position: absolute;
        bottom: $font-size-large + $space * 2.5;
        right: 120px;
        width: 100px;
        font-size: $font-size-mini;
      }
      .returns_on_death_label{
        position: absolute;
        bottom: $font-size-large + $space * 2.5;
        right: 250px;
        width: 150px;
        font-size: $font-size-mini;
      }
      .returns_on_death{
        position: absolute;
        bottom: $space;
        right: 250px;
        width: 56px;
        @include centering($height: 30px)
      }      
      .top_floor{
        position: absolute;
        top: $space;
        left: 100px;
        display: flex;
      }
      .deepest_floor{
        position: absolute;
        bottom: $space;
        left: 100px;
      }
      .descriptions{
        position: absolute;
        top: $space;
        right: $space;
        width: 70%;
        .dungeon_title{
          padding-left: $space;
          font-size: $font-size-large;
          border-bottom: 1px solid $gray3;
        }
        .description{
          font-size: $font-size-mini;
          height: 100px;
        }
      }
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
  .dungeon_title {
    min-width: 0.3em;
    animation: horizontal-text-in .2s cubic-bezier(0,.71,.17,.95) 0s;
  }
  .letter {
    display: inline-block;
    min-width: 0.3em;
    font-size: $font-size-mini;
    animation: vertical-text-in .2s cubic-bezier(0.22, 0.15, 0.25, 1.43) 0s backwards;
  }
  .main_image {
    animation: main-image 20s cubic-bezier(0,1.1,0,.98) 0s;
  }
</style>

<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'quest', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'quest', state: false})")
          .arrow
        .title
          | クエスト
      .description
        | 強敵と戦い、クエストを進行させます。
      .body
        .quest_list_tab.scrollable
          .daily.quest.hoverable.selectable(@click="selectQuest(dailyQuestId)" :class="questClass(dailyQuestId)")
            .name
              | ◆デイリー討伐◆
            .progress
              .current_progress(:class="questColorClass(dailyQuestId)")
                | {{todayRewardReceived}}
              |  / {{todayRewardLimit}}
          .quest.hoverable.selectable(
            v-for="quest in quests"
            @click="selectQuest(quest.id)"
            :class="questClass(quest.id)"
            )
            .name
              | {{quest.name}}
            .clear_mark
              .claar(v-if="quest.won_enemy_count === quest.enemy_count")
                | clear!
            .progress
              .current_progress(:class="questColorClass(quest.id)")
                | {{quest.won_enemy_count}}
              |  / {{quest.enemy_count}}
        .control_tab
          .main_image(:style="{backgroundImage: `url('images/quest/${selectingQuestId}.png')`}" :key="selectingQuestId")
          .controls.window
            .descriptions
              .quest_title(:key="selectingQuestId")
                | {{ selectingQuest.name }}
              .descri
                | {{ selectingQuest.description }}
              .progress(v-if="selectingQuestId !== dailyQuestId")
                .field_effect
                  .index
                    span
                      | フィールドエフェクト：
                    span.icon(v-if="currenFieldEffectState.icon")
                      img(:src="`/images/icons/states/${currenFieldEffectState.icon}`")
                    span
                      | {{currenFieldEffectState.title}}
                  .desc
                    | {{currenFieldEffectState.description}}
                .text
                  | {{ selectingQuest.won_enemy_count }} / {{ selectingQuest.enemy_count }} 体撃破
                .go.button.clickable(@click="openBattlePrepareWindow")
                  | Go!
              .progress(v-if="selectingQuestId === dailyQuestId")
                .field_effect
                  .index
                    span
                      | フィールドエフェクト：
                    span.icon(v-if="currenFieldEffectState.icon")
                      img(:src="`/images/icons/states/${currenFieldEffectState.icon}`")
                    span
                      | {{currenFieldEffectState.title}}
                  .desc
                    | 
                .text
                  | {{todayRewardReceived}} / {{todayRewardLimit}}
                .go.button.clickable(@click="openBattlePrepareWindow")
                  | Go!

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
      quests: [],
      stateLibrary: null,
      defaultState: {
        icon: null,
        title: "なし",
        description: "",
      },
      dailyQuestId: 999,
      dailyQuestDetail: {
        name: "◆デイリー討伐◆",
        description: "一期一会の遭遇戦だ！日替わりランダムな超強敵と戦って、星のカケラを手に入れよう！(出てくる敵の強さとカケラの取得制限量は通常クエスト戦で倒した敵の数によって決まります)",
        depth: "-",
        won_enemy_count: "-",
        enemy_count: "-"
      },
      todayRewardLimit: 0,
      todayRewardReceived: 0,
    };
  },
  props: {
  },
  store,
  mounted(){
    this.fetchPlayerQuests();
    this.stateLibrary = new StateLibrary();
  },
  computed: {
    selectingQuestId(){
      return this.$store.state.quest.quest_id;
    },
    selectingQuest(){
      if(this.selectingQuestId == this.dailyQuestId){
        return this.dailyQuestDetail;
      }
      return this.quests.find((x)=>x.id===this.selectingQuestId) || {};
    },
    currenFieldEffectState(){
      const stateId = this.quests.find((x)=>x.id===this.selectingQuestId)?.field_effect_state_id
      if(!this.stateLibrary || !stateId){
        return this.defaultState;
      }
      const state = this.stateLibrary.findState(stateId);
      return state || this.defaultState;
    }
  },
  methods: {
    selectFirstUnclearedQuest(){
      for(let quest of this.quests){
        if(quest.won_enemy_count !== quest.enemy_count){
          this.selectQuest(quest.id);
          return;
        }
      }
    },
    selectQuest(questId){
      this.$store.commit("quest/setQuest", questId);
    },
    fetchPlayerQuests(){
      const path = `/quests.json`;
      ax.get(path)
        .then((results) => {
          console.log(results);
          this.quests = results.data.quests;
          this.todayRewardLimit = results.data.today_reward_limit;
          this.todayRewardReceived = results.data.today_reward_received;
          this.selectFirstUnclearedQuest();
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        }
      );
    },
    openBattlePrepareWindow(){
      this.$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: true});
    },
    questClass(questId){
      if(questId == this.selectingQuestId){
        return "selected";
      }
      return "not_selected";
    },
    questColorClass(questId){
      return "";
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
  .quest_list_tab{
    margin: $thin_space;
    display: flex;
    flex-direction: column;
    height: 430px;
    width: 380px;
    line-height: 100%;
    .quest{
      margin: $thin_space;
      padding: $space * 1.5;
      width: calc(100% - 10px);
      display: flex;
      .name{
        width: 70%;
      }
      .clear_mark{
        width: 15%;
      }
      .progress{
        .current_progress{
          display: inline-block;
        }
        .cleared{
          color: $yellow;
        }
        flex: 1;
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
      background-position: 0 0;
      image-rendering: pixelated;
    }
    .controls{
      margin-top: $space;
      height: 232px;
      margin-right: $space;
      .descriptions{
        display: flex;
        flex-direction: column;
        height: 100%;
        .quest_title{
          padding-left: $space;
          padding-bottom: $thin_space;
          font-size: $font-size-large;
          border-bottom: 1px solid $gray3;
          height: calc($font-size-lage + $thin_space * 2);
        }
        .descri{
          height: 114px;
          font-size: $font-size-mini;
          border-bottom: 1px solid $gray3;
          padding: $space;
        }
        .progress{
          padding: $space;
          display: flex;
          justify-content: flex-end;
          align-items: flex-end;
          height: 86px;
          .field_effect{
            height: 100%;
            .index{
              display: flex;
              align-items: center;
              height: 24px;
              min-width: 1px;
              margin-bottom: 2px;
            }
            .desc{
              width: 340px;
              line-height: 120%;
              font-size: $font-size-mini;
              white-space: pre-wrap;
            }
            .icon{
              margin-right: $thin_space;
            }
            padding-right: $thin_space;
          }
          .text{
            font-size: $font-size-large;
            padding-right: $space;
            width: 130px;
          }
          .go{
            height: 50px;
            width: 100px;
            font-size: $font-size-large;
            padding-top: ((50px - $font-size-large) / 2);
            line-height: 100%;
            text-align: center;
          }
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
      background-position: 0 20px;
      opacity: 0.5;
    }
  }
  .quest_title {
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
    animation: main-image 1s cubic-bezier(.31,.99,1,.99) 0s;
  }
</style>

<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'quest', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'quest', state: false})")
        .title
          | クエスト
      .description
        | 強敵と戦い、クエストを進行させます。
      .body
        .quest_list_tab
          .quest.hoverable(
            v-for="quest in quests"
            @click="selectQuest(quest.id)"
            :class="questClass(quest.id)"
            )
            .name
              | {{quest.name}}
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
              .description
                | {{ selectingQuest.description }}
              .progress
                .text
                  | {{ selectingQuest.won_enemy_count }} / {{ selectingQuest.enemy_count }} 体撃破
                .go.button.clickable(@click="openBattlePrepareWindow")
                  | Go!

</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      quests: [],
    };
  },
  props: {
  },
  store,
  mounted(){
    this.fetchPlayerQuests();
  },
  computed: {
    selectingQuestId(){
      return this.$store.state.quest.quest_id;
    },
    selectingQuest(){
      return this.quests.find((x)=>x.id===this.selectingQuestId) || {};
    },
  },
  methods: {
    selectQuest(questId){
      this.$store.commit("quest/setQuest", questId);
    },
    fetchPlayerQuests(){
      const path = `/quests.json`;
      ax.get(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.quests = results.data.quests;
          this.selectQuest(results.data.quests[0]?.id || 1);
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
    padding: $space;
    display: flex;
    flex-direction: column;
    height: 430px;
    width: 380px;
    .selected{
      background-color: $gray3;
      border: 1px solid $yellow;
    }
    .not_selected{
      border: 1px solid transparent;
    }
    .quest{
      margin: $thin_space;
      padding: $space;
      width: 100%;
      .name{
        display: inline-block;
        width: 60%;
      }
      .progress{
        .current_progress{
          display: inline-block;
        }
        .cleared{
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
      height: 232px;
      .descriptions{
        padding: $thin_space;
        .quest_title{
          padding-left: $space;
          font-size: $font-size-large;
          border-bottom: 1px solid $gray3;
          height: 20%;
        }
        .description{
          font-size: $font-size-mini;
          height: 50%;
        }
        .progress{
          padding: $space;
          display: flex;
          justify-content: flex-end;
          align-items: flex-end;
          height: 30%;
          .text{
            font-size: $font-size-large;
            padding-right: $space;
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
      background-position: 0 0;
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
    animation: main-image 20s cubic-bezier(0,1.1,0,.98) 0s;
  }
</style>
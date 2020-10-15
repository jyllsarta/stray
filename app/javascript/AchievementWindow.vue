<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'achievement', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'achievement', state: false})")
        .title
          | 実績
      .description
        | これまでに取得した実績を確認できます。報酬がある場合受け取れます。
      .body
        .achievements
          transition-group(name="achievement-animation")
            .achievement.selectable.hoverable(
              v-for="achievementStep in sortedAchievementSteps()",
              @mouseover="$store.commit('guide/updateGuide', achievementStep.description)",
              @click="selectAchievementStep(achievementStep.id)",
              :class="[achievementStep.id === selectingAchievementStepId ? 'selected' : 'not_selected', achievementStepStatus(achievementStep.id)]"
              :key="achievementStep.id"
            )
              .height_block
              .icon.item
                img(src="/images/icons/achievements/treasure.gif")
              .title.item
                | {{achievementStep.title}}
              .progress.item
                .current
                  | {{userAchievements[achievementStep.achievement_id] ? userAchievements[achievementStep.achievement_id].progress : 0}}
                .sep
                  | /
                .target
                  | {{achievementStep.progress}}
              .receive.item
                | {{achievementLabels[achievementStepStatus(achievementStep.id)]}}
        .details
          .summary
            .label
              | トータル実績達成率：
            .value
              | {{currentProgressPercentage()}}%
          .detail
            .descri
              | 選択中の実績：
            .titles
              .icon
                img(src="/images/icons/achievements/treasure.gif")
              .title
               | {{selectingAchievementStep.title}}
            .description
              | {{selectingAchievementStep.description}}
            .current.key_value
              .key
                | 現在値：
              .value
                |  {{userAchievements[selectingAchievementStep.achievement_id] ? userAchievements[selectingAchievementStep.achievement_id].progress : 0}}
            .taeget.key_value
              .key
                | 目標値：
              .value
                | {{selectingAchievementStep.progress}}
            .reward.key_value
              .key
                | 報酬：
              .value
                .icon
                  img(src="/images/ui/star.png")
                .amount
                  | x{{selectingAchievementStep.rewards[0] ? selectingAchievementStep.rewards[0].amount : 0}}
            .reward_button_area
              .reward_button.hoverable(
                :class="achievementStepStatus(selectingAchievementStep.id)"
                @click="onReceiveRewardButtonClick(selectingAchievementStep.id)"
              )
                | {{achievementLabels[achievementStepStatus(selectingAchievementStep.id)]}}
</template>

<script lang="ts">
  import Constants from "./packs/constants.ts";
    import store from './packs/store.ts'
    import axios from 'axios'
    import ax from "./packs/axios_default_setting.ts";
    import SkillList from "./SkillList.vue";
    import CardList from "./CardList.vue";
    import Card from "./packs/quest/card";

  export default {
    components: {
    },
    data: function () {
      return {
        selectingAchievementStepId: -1,
        userAchievements: {},
        userAchievementSteps: {},
        achievementLabels: {
          cleared: "達成",
          in_progress: "進行中",
          reward_received: "受取済"
        },
        achievementPriorities: {
          cleared: 1,
          in_progress: 2,
          reward_received: 3,
        },
        isReceiving: false,
      };
    },
    mounted(){
      this.fetchPlayerAchievements();
    },
    store,
    computed: {
      achievementSteps(){
        return Object.values(this.$store.state.masterdata.achievement_steps);
      },
      selectingAchievementStep(){
        const achievement = this.$store.state.masterdata.achievement_steps[this.selectingAchievementStepId];
        if(achievement){
          return achievement;
        }
        return {
          title: "-",
          description: "",
          progress: "-",
          rewards: [
            {
              amount: "-"
            }
          ]
        }
      },
    },
    methods: {
      sortedAchievementSteps(){
        const active_steps = this.removeDuplicateAchievementIdFromSteps([this.filteredAchievementStepsByStatus('cleared'), this.filteredAchievementStepsByStatus('in_progress')].flat());
        return [active_steps, this.filteredAchievementStepsByStatus('reward_received')].flat();
      },
      // achievement_steps のリストから同一achievement_id のものは最初の一つだけを残す
      removeDuplicateAchievementIdFromSteps(steps){
        let filtered = [];
        let achievement_ids = [];
        for(let step of steps){
          if(!achievement_ids.includes(step.achievement_id)){
            filtered.push(step);
            achievement_ids.push(step.achievement_id);
          }
        }
        return filtered;
      },
      filteredAchievementStepsByStatus(key){
        const steps = Object.values(this.$store.state.masterdata.achievement_steps);
        return steps.filter((x)=>{return this.achievementStepStatus(x.id) === key})
      },
      currentProgressPercentage(){
        const steps = Object.keys(this.$store.state.masterdata.achievement_steps);
        return Math.floor(steps.filter((x)=>{return this.achievementStepStatus(x) != 'in_progress'}).length / steps.length * 100);
      },
      selectAchievementStep(id){
        console.log(id);
        this.selectingAchievementStepId = id;
      },
      fetchPlayerAchievements(){
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/achievements.json`;
        ax.get(path)
          .then((results) => {
            console.log(results);
            this.userAchievements = results.data.achievements;
            this.userAchievementSteps = results.data.achievement_steps;
          })
          .catch((error) => {
            console.warn(error.response);
            console.warn("NG");
          });
      },
      achievementStepStatus(achievement_step_id){
        if(this.userAchievementSteps[achievement_step_id]){
          return "reward_received";
        }
        const step = this.$store.state.masterdata.achievement_steps[achievement_step_id];
        if(!step){
          return "in_progress";
        }
        if(this.userAchievements[step.achievement_id]?.progress >= step.progress){
          return "cleared";
        }
        return "in_progress";
      },
      onReceiveRewardButtonClick(achievement_step_id) {
        if(this.isReceiving){
          console.log("通信中...")
          return;
        }
        if(this.achievementStepStatus(achievement_step_id) === "cleared"){
          this.receiveReward(achievement_step_id);
        }
        console.log("クリア意外なのでスルーします");
      },
      receiveReward(achievement_step_id) {
        this.isReceiving = true;
        const user_id = localStorage.user_id;
        const path = `/users/${user_id}/user_achievement_steps/receive_reward.json`;
        ax.post(path, { achievement_step_id: achievement_step_id })
          .then((results) => {
            console.log(results);
            this.$store.dispatch('user/fetchUserModel');
            // 受け取り済み扱いにする
            this.$set(this.userAchievementSteps, achievement_step_id, {achievement_step_id: achievement_step_id});
            // 画面中で一番上に来るやつを選択し直す
            this.selectAchievementStep(this.sortedAchievementSteps()[0].id);
            this.isReceiving = false;
          })
          .catch((error) => {
            console.warn(error);
            console.warn(error.response);
            console.warn("NG");
          }
        );
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

    .achievements{
      display: flex;
      flex-direction: column;
      height: 440px;
      overflow-y: scroll;
      width: 75%;
      .achievement{
        margin: $thin_space / 2;
        width: calc(100% - 8px);
        display: flex;
        flex-direction: row;
        align-items: center;
        .height_block{
          height: 40px; // achievement 全体の高さをこいつで決めている
        }
        .item{
          margin-left: $thin_space;
          margin-right: $thin_space;
        }
        .icon{
          width: 24px;
          height: 24px;
        }
        .title{
          flex-grow: 1;
          font-size: 18px; // ここも妙に通常サイズだと小さく見えるので特異なサイズにする...
        }
        .progress{
          .current, .target{
            display: inline-block;
            min-width: 3rem;
            text-align: right;
          }
          .sep{
            display: inline-block;
            width: 1rem;
            text-align: center;
          }
        }
        .reward_icon{
          width: 20px;
          height: 20px;
          img{
            width: 100%;
            height: 100%;
          }
        }
        .amount{
          width: 20px;
        }
        .receive{
          @include centering($height: 30px);
          width: 60px;
          margin-right: 20px;
        }
      }
    }
    .details{
      width: 25%;
      padding: $space;
      .summary{
        border-bottom: 1px solid $gray3;
        .label{
        }
        .value{
          width: 100%;
          font-size: $font-size-large;
          text-align: right;
        }
      }
      .detail{
        .titles{
          height: 50px;
          display: flex;
          align-items: center;
          .icon{
            display: inline-block;
            width: 24px;
            height: 24px;
          }
          .title{
            display: inline-block;
            padding-left: $space;
            font-size: 18px;
            line-height: 110%;
          }
        }
        .description{
          height: 100px;
        }
        .key_value{
          padding-top: $space;
          height: 40px;
          .key{
            display: inline-block;
            width: 30%;
            margin-left: 10%;
            text-align: right;
          }
          .value{
            display: inline-block;
            padding-left: $thin_space;
            width: 60%;
          }
        }
        .reward{
          .icon{
            display: inline-block;
            width: 24px;
            height: 24px;
            img{
              width: 100%;
              height: 100%;
            }
          }
          .amount{
            display: inline-block;
          }
        }
        .reward_button_area{
          width: 100%;
          height: 80px;
          display: flex;
          justify-content: center;
          align-items: center;
          .reward_button{
            @include centering($height: 60px);
            width: 140px;
            border: 1px solid $gray3;
            border-radius: $radius;
          }
        }
      }
    }
    .in_progress{
      border: 1px solid transparent;
    }
    .cleared{
      background-color: $yellow-opacity;
      border: 1px solid $gray1;
      &:hover{
        background-color: $yellow-opacity;
        filter: brightness(130%);
        transform: scale(1.03);
      }
    }
    .reward_received{
      background-color: $background_with_opacity;
      border: 1px solid transparent;
      opacity: 0.5;
    }

    .achievement{
      transition: all 0.5s;
    }
    .achievement-animation-leave-to {
      opacity: 0;
      transform: scale(1.3);
    }
    .achievement-animation-leave-active {
      position: absolute;
    }
  }
</style>

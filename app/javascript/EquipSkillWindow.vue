<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false})")
        .title
          | スキル選択
      .description
        | スキルのつけ外しをします。
      .body
        .main
          .skill_select_area
            .head
              | 所持スキル
            .all_skills.skills
              SkillList(:isPlayer="true", :skills="remainingSkills", @onClick="selectSkill")
            .head
              | 装備中のスキル
            .selected_skills.skills
              SkillList(:isPlayer="true", :skills="selectedSkills", @onClick="selectSkill")
          .detail_area
        .decide_area
          .decide.clickable(@click="decide")
            | 確定して閉じる



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
        SkillList,
      },
      data: function () {
          return {
              playerSkills: [],
              selectingSkillIds: [],
          };
      },
      mounted(){
          this.fetchPlayerSkills();
      },
      store,
      computed: {
          selectedSkills(){
              return this.playerSkills.filter((x)=>this.selectingSkillIds.includes(x.id));
          },
          remainingSkills(){
              return this.playerSkills.filter((x)=>!this.selectingSkillIds.includes(x.id));
          },
      },
      methods: {
          selectSkill(id){
              if(this.selectingSkillIds.includes(id)){
                  this.selectingSkillIds = this.selectingSkillIds.filter(n => n !== id);
                  return;
              }
              if(this.selectingSkillIds.length === 5){ //Constants 依存のがいいかな？
                  return;
              }
              this.selectingSkillIds.push(id);
          },
          fetchPlayerSkills(){
              const path = `/skills.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.playerSkills = results.data.skills;

                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },
          decide(){
              const path = `/skills/equip.json`;
              const params = {
                  skill_ids: this.selectingSkillIds,
              };
              ax.post(path, params)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false});
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          }
      }
  }
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";

  *{
    //outline: 1px solid #79f850;
  }

  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }

  .body{
    .main{
      padding: $space;
      display: flex;
      .skill_select_area {
        width: 70%;
        .head{
          border-bottom: 1px solid $gray3;
          width: 100%;
          margin-bottom: $space;
        }
        .skills{
          height: 100px;
        }
      }
      .detail_area{
        width: 30%;
        height: 350px;
      }
    }
    .decide_area{
      width: 100%;
      display: flex;
      justify-content: center;
      .decide{
        width: 150px;
        @include centering(50px);
      }
    }
  }

</style>

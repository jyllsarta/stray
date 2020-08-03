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
              SkillList(:isPlayer="true", :skills="remainingSkills", :clickable="true", @onClick="selectSkill", @onPoint="pointSkill")
            .head
              | 装備中のスキル
            .selected_skills.skills
              SkillList(:isPlayer="true", :skills="selectedSkills", :clickable="true", @onClick="selectSkill", @onPoint="pointSkill")
          .detail_area
            .head
              | スキル詳細
            .names
              img.icon(:src="iconImagePath(pointingSkill.id)")
              .name
                | {{pointingSkill.name}}
            .details
              .detail
                .key
                  | コスト
                .value
                  | {{pointingSkill.cost}}
              .detail
                .key
                  | 使用回数
                .value
                  | {{pointingSkill.reusable ? '∞' : '1'}}
              .detail(v-if="pointingSkill.is_defence===true")
                .key
                  | 防御スキル
                .value
                  |
              .descri
                | {{pointingSkill.description}}
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
              selectingSkillIds: [],
              pointingSkillId: 0,
          };
      },
      mounted(){
          this.fetchPlayerSkills();
      },
      store,
      computed: {
          selectedSkills(){
              return this.$store.state.skill.skills.filter((x)=>this.selectingSkillIds.includes(x.id));
          },
          remainingSkills(){
              return this.$store.state.skill.skills.filter((x)=>!this.selectingSkillIds.includes(x.id));
          },
          pointingSkill(){
              const stub = {
                  name: "-",
                  cost: "-",
                  reusable: false,
                  description: "",
                  is_defence: "false",
              };
              return this.$store.state.skill.skills.find((x)=>x.id===this.pointingSkillId) || stub;
          }
      },
      methods: {
        iconImagePath(skillId){
          if(!this.$store.state.masterdata?.skills[skillId]){
            return "/images/icons/skill/default.gif";
          }
          return `/images/icons/skill/${this.$store.state.masterdata.skills[skillId]?.icon_image_path}`;
        },
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
          pointSkill(id){
            this.pointingSkillId = id;
          },
          fetchPlayerSkills(){
              const path = `/skills.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      console.log("OK");
                      this.$store.commit("skill/setPlayerSkills", results.data.skills);
                      this.selectingSkillIds = this.$store.state.skill.skills.filter((x)=>x.is_equipped).map((x)=>x.id);
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
                      this.fetchPlayerSkills(); // 編集結果を再読み込み、ひっじょーに無駄が多いけど、一旦これで
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
        .all_skills{
          height: 230px;
          .skill_list{
            flex-wrap: wrap;
          }
        }
        .selected_skills{
          height: 70px;
          .skill_list{
            flex-wrap: wrap;
          }
        }
      }
      .detail_area{
        width: 30%;
        height: 350px;
        padding-left: $space;
        .head{
          border-bottom: 1px solid $gray3;
          width: 100%;
          margin-bottom: $space;
          padding-left: $space;
        }
        .names{
          width: 100%;
          border-bottom: 1px solid $gray3;
          height: 40px;
          display: flex;
          align-items: center;
          margin-bottom: $space;
          .name{
            line-height: 100%;
            padding-top: 2px;
            font-size: $font-size-large;
            height: 24px;
            padding-left: $space;
          }
          .icon{
            width: 24px;
            height: 24px;
            margin-left: $thin_space;
          }
        }
        .details{
          .detail{
            display: flex;
            align-items: baseline;
            padding: $space;
            border-bottom: 1px solid $gray3;
            .key{
              text-align: right;
              width: 50%;
              height: $font-size-normal;
              line-height: 100%;
              padding-right: $space;
              border-right: 1px solid $gray3;
            }
            .value{
              padding-left: $space;
              width: 50%;
              height: $font-size-normal;
              line-height: 100%;
            }
          }
        }
        .descri{
          padding: $thin_space;
        }
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

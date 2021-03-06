<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: false})")
          .arrow
        .title
          | スキル選択
      .description
        | スキルのつけ外しをします。
      .body
        .main
          .skill_select_area
            .head
              | 所持スキル
            .all_skills.skills.scrollable
              SkillList(:isPlayer="true", :skills="remainingSkills", :clickable="true", @onClick="selectSkill", @onPoint="pointSkill")
            .head
              | 装備中のスキル
            .selected_skills_area
              .skills
                SkillList(:isPlayer="true", :skills="selectedSkills", :clickable="true", @onClick="selectSkill", @onPoint="pointSkill")
              .limit
                span(:class="isSkillSlotMax ? 'limit' : ''")
                  | {{ selectedSkills.length }}
                span
                  | / {{ $store.state.user.status.skill_slot_count }}
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
              .detail(
                v-if="pointingSkill.threshold_hp"
                @mouseover="$store.commit('guide/updateGuide', '特定HP以下になると発動可能。')"
              )
                .key
                  | 条件
                .value
                  | {{pointingSkill.threshold_hp}}≦HP
              .detail(
                v-if="pointingSkill.is_defence===true"
                @mouseover="$store.commit('guide/updateGuide', '防御スキルの使用ターンはMPが増加しない。')"
                )
                .center_key
                  | 防御スキル
              .detail(
                v-if="pointingSkill.is_passive===true"
                @mouseover="$store.commit('guide/updateGuide', 'パッシブスキル。バトル開始時に自動発動する。')"
                )
                .center_key
                  | パッシブ
              .detail(
                v-if="pointingSkill.is_exhaust===true"
                @mouseover="$store.commit('guide/updateGuide', 'イグゾーストスキルはMPがマイナスでなければいつでも使用できる。')"
                )
                .center_key
                  | イグゾースト
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
          },
          isSkillSlotMax(){
            return this.selectingSkillIds.length === this.$store.state.user.status.skill_slot_count
          },
      },
      methods: {
        iconImagePath(skillId){
          if(!this.$store.state.masterdata?.skills[skillId]){
            return "/images/icons/skill/default.gif";
          }
          return `/images/icons/skill/${this.$store.state.masterdata.skills[skillId]?.icon_image_path}`;
        },
        selectSkill(emittedObject){
              const id = emittedObject.skillId;
              if(this.selectingSkillIds.includes(id)){
                  this.selectingSkillIds = this.selectingSkillIds.filter(n => n !== id);
                  return;
              }
              if(this.isSkillSlotMax){
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
            height: 100%;
            align-items: flex-start;
            flex-wrap: wrap;
            align-content: flex-start;
          }
        }
        .selected_skills_area{
          display: flex;
          height: 70px;
          width: 100%;
          .skills{
            width: 85%;
            height: 100%;
            align-items: flex-start;
          }
          .limit{
            width: 15%;
            text-align: right;
            font-size: $font-size-large;
            .limit{
              color: $yellow;
            }
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
            padding: $thin_space;
            border-bottom: 1px solid $gray3;
            .key{
              text-align: right;
              width: 50%;
              border-right: 1px solid $gray3;
              padding-right: $thin_space;
            }
            .value{
              width: 50%;
              padding-left: $thin_space;
            }
            .center_key{
              width: 100%;
              text-align: center;
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

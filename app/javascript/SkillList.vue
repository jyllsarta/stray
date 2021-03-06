<template lang="pug">
  .skill_list(:class="sideClass")
    .skill(
      v-for="(skill, index) in skills"
        @click="$emit('onClick', {skillId: skill.id, skillIndex: index})"
        @mouseover="onPoint(skill.id)"
        :class="`${skillClass(index)} ${isPassiveSkill(skill)}`"
      )
      .mimi(v-if="skillActivationOrder(index)")
        | {{skillActivationOrder(index)}}
      .debug_rank(v-if="debugEnableShowSkillRank")
        | {{skill.grade}}
      .upper
        img.icon(:src="iconImagePath(skill.id)")
        .cost(v-if="!skill.threshold_hp && !skill.is_passive")
          | {{skill.cost}}
        .cost(v-if="skill.threshold_hp")
          | HP≦{{skill.threshold_hp}}
        .additional_text
          | {{additionalText(skill)}}
      .downer
        .name
          | {{skill.name}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";
import BattleFactory from "./packs/quest/battle_factory"
import Battle from "./packs/quest/battle"

export default {
  data: function () {
    return {

    };
  },
  props: {
    isPlayer: Boolean,
    skills: Array,
    clickable: Boolean,
    battle: Object,
  },
  store,
  mounted(){
  },
  computed: {
    sideClass(){
      return this.isPlayer ? "player_skill_list" : "enemy_skill_list";
    },
    debugEnableShowSkillRank(){
      return process.env.NODE_ENV !== 'production';
    }
  },
  methods: {
    onPoint(skillId){
      this.$emit('onPoint', skillId);
      this.$store.commit('guide/updateGuide', this.$store.state.masterdata.skills[skillId]?.description);
    },
    skillClass(skillIndex) {
      if(!this.battle){
        return this.clickable ? 'clickable' : '';
      }
      if(this.isPlayer){
        return this.skillClassPlayer(skillIndex);
      }else{
        return this.skillClassEnemy(skillIndex);
      }
    },
    skillCostSufficient(skill){
      const consumeMp = this.battle.player.selectingSkills().reduce((a,b)=>a+b.cost, 0);
      const remainingMp = this.battle.player.mp - consumeMp;
      return skill.isMpSufficient(remainingMp);
    },
    skillClassPlayer(skillIndex){
      const skill = this.battle.player.skills[skillIndex];
      let usedSkills = this.battle.player.operationHistory.map((x)=>x.skillIndex);
      if(this.battle.phaseIndex() >= 2 && this.battle.player.selectingSkillIndexes.length > 1){ // is プレイヤースキル発動フェーズ
        usedSkills = usedSkills.concat(this.battle.player.selectingSkillIndexes);
      }

      // MEMO: パッシブ・イグゾースト・HP条件のスキルはそれぞれ canUseSkill で状態が制御される

      // すでに使用してもう使えないスキルは一番暗い色になる
      if(!skill.reusable && usedSkills.flat().includes(skillIndex)) {
        return 'used';
      }

      // スキルを単純に使えないときは暗くなる
      if(!this.battle.player.canUseSkill(skillIndex)){
        return 'disabled';
      }

      // このターン選んでいるスキルは明るくなる 
      if(this.battle.player.selectingSkillIndexes.includes(skillIndex)){
        return 'selected';
      }

      // 同ターンの予算編成的にもう選べないスキルは暗くなる
      if(!this.skillCostSufficient(skill)){
        return 'disabled';
      }

      // 全ての選べない条件を回避し、かつ今選んでいないスキルは通常表記となる
      return 'available';
    },
    skillClassEnemy(skillIndex){
      const skill = this.battle.enemy.skills[skillIndex];
      let usedSkills = this.battle.enemy.operationHistory.map((x)=>x.skillIndex);
      if(this.battle.phaseIndex() >= 3 && this.battle.enemy.selectingSkillIndexes.length > 1){ // is エネミースキル発動フェーズ
        usedSkills = usedSkills.concat(this.battle.enemy.selectingSkillIndexes);
      }
      if(!skill.reusable && usedSkills.flat().includes(skillIndex)) {
        return 'used';
      }
      if(!this.battle.enemy.canUseSkill(skillIndex)){
        return 'disabled';
      }
      return this.battle.enemy.selectingSkillIndexes.includes(skillIndex) ? 'selected' : 'available';
    },
    iconImagePath(skillId){
      if(!this.$store.state.masterdata?.skills[skillId]){
        return "/images/icons/skill/default.gif";
      }
      return `/images/icons/skill/${this.$store.state.masterdata.skills[skillId]?.icon_image_path}`;
    },
    skillActivationOrder(skillIndex){
      if(!this.battle || !this.isPlayer || this.battle.player.selectingSkillIndexes.length < 2){
        return;
      }
      const idx = this.battle.player.selectingSkillIndexes.indexOf(skillIndex);
      return idx == -1 ? null : (idx + 1);
    },
    additionalText(skill){
      let text = "";
      if(skill.reusable){
        text += "∞";
      }
      if(skill.is_exhaust){
        text += "x";
      }
      return text;
    },
    isPassiveSkill(skill){
      return skill.is_passive ? "passive" : "";
    }
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
.skill_list{
  display: flex;
  .skill{
    position: relative;
    margin: $thin_space / 2;
    padding: $thin_space / 2;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    border: 1px solid $gray3;
    border-radius: $radius;
    width: 90px;
    height: 60px;
    .debug_rank{
      position: absolute;
      top: 0;
      right: 0;
      line-height: 100%;
    }
    .mimi{
      position: absolute;
      top: -4px;
      left: -4px;
      line-height: 100%;
      border-radius: $radius;
      height: 20px;
      width: 20px;
      text-align: center;
      padding-top: 2px;
      background-color: $background;
      border: 1px solid $gray2;
    }
    .upper{
      text-align: center;
      .icon{
        width: 24px;
        height: 24px;
        margin-right: 2px;
        display: inline-block;
      }
      .cost{
        display: inline-block;
        margin-right: 2px;
      }
      .additional_text{
        display: inline-block;
      }
    }
    .downer{
      .name{
        text-align: center;
      }
    }
  }

  .used{
    opacity: 0.25;
    cursor: default;
  }
  .available{
    background-color: $gray3-opacity;
    cursor: pointer;
  }
  .available{
    &:hover{
      border: 1px solid $yellow;
      transform: scale(1.1);
    }
  }
  .passive{
    border-radius: 24px 0 24px 0;
    background-color: transparent;
    .downer{
      color: $accent-color;
    }
  }
}

.player_skill_list{
  justify-content: flex-start;
}

.enemy_skill_list{
  justify-content: flex-end;
}
</style>

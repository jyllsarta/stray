<template lang="pug">
  .skill_list(:class="sideClass")
    .skill(
      v-for="(skill, index) in skills"
        @click="$emit('onClick', {skillId: skill.id, skillIndex: index})"
        @mouseover="onPoint(skill.id)"
        :class="skillClass(index)"
      )
      .mimi(v-if="skillActivationOrder(index)")
        | {{skillActivationOrder(index)}}
      .upper
        img.icon(:src="iconImagePath(skill.id)")
        .cost
          | {{skill.cost}}
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
      if (this.isPlayer) {
        return this.skillClassPlayer(skillIndex);
      } else {
        return this.skillClassEnemy(skillIndex);
      }
    },
    skillCostSufficient(cost){
      const consumeMp = this.battle.player.selectingSkills().reduce((a,b)=>a+b.cost, 0);
      const remainingMp = this.battle.player.mp - consumeMp;
      return remainingMp >= cost;
    },
    skillClassPlayer(skillIndex){
      const skill = this.battle.player.skills[skillIndex];
      let usedSkills = this.battle.operationHistory.map((x)=>x.skillIndex);
      if(this.battle.phaseIndex() >= 2 && this.battle.player.selectingSkillIndexes.length > 1){ // is プレイヤースキル発動フェーズ
        usedSkills = usedSkills.concat(this.battle.player.selectingSkillIndexes);
      }

      // MEMO: パッシブ・イグゾースト・HP条件のスキルはそれぞれ canUseSkill で状態が制御される

      // すでに使用してもう使えないスキルは一番暗い色になる
      if(!skill.reusable && usedSkills.flat().includes(skillIndex)) {
        return 'used';
      }

      // スキルを単純に使えないときは暗くなる
      if(!this.battle.canUseSkill(skillIndex)){
        return 'disabled';
      }

      // このターン選んでいるスキルは明るくなる 
      if(this.battle.player.selectingSkillIndexes.includes(skillIndex)){
        return 'animation_selected';
      }

      // 同ターンの予算編成的にもう選べないスキルは暗くなる
      if(!this.skillCostSufficient(skill.cost)){
        return 'disabled';
      }

      // 全ての選べない条件を回避し、かつ今選んでいないスキルは通常表記となる
      return 'available';
    },
    skillClassEnemy(skillIndex){
      const skill = this.battle.enemy.skills[skillIndex];
      let usedSkills = this.battle.enemyOperationHistory.map((x)=>x.skillIndex);
      if(this.battle.phaseIndex() >= 3 && this.battle.enemy.selectingSkillIndexes.length > 1){ // is エネミースキル発動フェーズ
        usedSkills = usedSkills.concat(this.battle.enemy.selectingSkillIndexes);
      }
      if(!skill.reusable && usedSkills.flat().includes(skillIndex)) {
        return 'used';
      }
      if(!this.battle.canEnemyUseSkill(skillIndex)){
        return 'disabled';
      }
      return this.battle.enemy.selectingSkillIndexes.includes(skillIndex) ? 'animation_selected' : 'available';
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
        text += "X";
      }
      return text;
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
  .selected{
    background-color: $gray3;
    border: 1px solid $yellow;
    cursor: pointer;
  }
  .animation_selected {
    animation: animate-stripes 12s linear infinite;
    background-size: 15px 15px;
    background-image: linear-gradient(
        135deg,
        $gray3 25%,
        $gray3-opacity 25%,
        $gray3-opacity 50%,
        $gray3 50%,
        $gray3 75%,
        $gray3-opacity 75%,
        $gray3-opacity
    );
    border: 1px solid $yellow;
    background-repeat: repeat;
  }  

  .disabled{
    background-color: $gray3-opacity;
    opacity: 0.5;
    cursor: default;
  }
  .used{
    opacity: 0.25;
    cursor: default;
  }
  .available{
    background-color: $gray3-opacity;
    cursor: pointer;
  }
  .selected, .available{
    &:hover{
      border: 1px solid $yellow;
      transform: scale(1.1);
    }
  }
}

.player_skill_list{
  justify-content: flex-start;
}

.enemy_skill_list{
  justify-content: flex-end;
}

@keyframes animate-stripes {
  0% {
    background-position: 0 0;
    border-color: $yellow;
  }

  25% {
    border-color: $plus;
  }

  50% {
    border-color: $yellow;
  }

  25% {
    border-color: $plus;
  }

  100% {
    background-position: 60px 0;
    border-color: $yellow;
  }
}

</style>

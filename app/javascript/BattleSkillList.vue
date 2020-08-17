<template lang="pug">
  .skill_list(:class="sideClass")
    .skill(v-for="(skill, index) in skills"
           @click="$emit('onClick', {skillId: skill.id, skillIndex: index})"
           @mouseover="onPoint(skill.id)"
           :class="skillClass(index)"
           )
      .upper
        img.icon(:src="iconImagePath(skill.id)")
        .cost
          | {{skill.cost}}
        .infinite
          | {{skill.reusable ? '∞' : ''}}
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
    battle: Object,
  },
  store,
  mounted(){
  },
  computed: {
    sideClass(){
      return this.isPlayer ? "player_skill_list" : "enemy_skill_list";
    }
  },
  methods: {
    onPoint(skillId){
      this.$emit('onPoint', skillId);
      this.$store.commit('guide/updateGuide', `${this.$store.state.masterdata.skills[skillId]?.name}：${this.$store.state.masterdata.skills[skillId]?.description}`);
    },
    skillClass(skillIndex) {
      if (this.isPlayer) {
        return this.skillClassPlayer(skillIndex);
      } else {
        return this.skillClassEnemy(skillIndex);
      }
    },
    skillClassPlayer(skillIndex){
      const skill = this.battle.player.skills[skillIndex];
      if(!skill.reusable && this.battle.operationHistory.map((x)=>x.skillIndex).includes(skillIndex)) {
          return 'used';
      }
      if(!this.battle.canUseSkill(skillIndex)){
        return 'disabled';
      }
      return this.battle.player.selectingSkillIndex === skillIndex ? 'selected' : 'available';
    },
    skillClassEnemy(skillIndex){
      const skill = this.battle.enemy.skills[skillIndex];
      if(!skill.reusable && this.battle.enemyOperationHistory.map((x)=>x.skillIndex).includes(skillIndex)){
        return 'used';
      }

      if(!this.battle.canEnemyUseSkill(skillIndex)){
        return 'disabled';
      }
      return this.battle.enemy.selectingSkillIndex == skillIndex ? 'selected' : 'available';
    },
    iconImagePath(skillId){
      if(!this.$store.state.masterdata.skills){
        return "/images/icons/skill/default.gif";
      }
      return `/images/icons/skill/${this.$store.state.masterdata.skills[skillId]?.icon_image_path}`;
    }
  },
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";

.skill_list{
  display: flex;
  .skill{
    margin: $thin_space / 2;
    padding: $thin_space / 2;
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    border: 1px solid $gray3;
    border-radius: $radius;
    width: 90px;
    height: 60px;
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
      .infinite{
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
  }
  .disabled{
    background-color: $gray3-opacity;
    opacity: 0.5;
  }
  .used{
    opacity: 0.25;
  }
  .available{
    background-color: $gray3-opacity;
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
</style>

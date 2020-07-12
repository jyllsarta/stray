<template lang="pug">
  .skill_list(:class="sideClass")
    .skill(v-for="skill in skills" @click="$emit('onClick', skill.id)", @mouseover="$emit('onPoint', skill.id)", :class="skillClass(skill)")
      .name
        | {{skill.name}}
      .cost
        | {{skill.cost}}
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
    skillClass(skill){
      return this.battle.selectingSkillId == skill.id ? 'selected' : '';
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
    .name, .cost{
      text-align: center;
    }
  }
  .selected{
    background-color: $gray3;
    border: 1px solid $yellow;
  }
  .disabled{
    opacity: 0.5;
  }
}

.player_skill_list{
  justify-content: flex-start;
}

.enemy_skill_list{
  justify-content: flex-end;
}
</style>

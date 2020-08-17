<template lang="pug">
  .skill_list(:class="sideClass")
    .skill(
      v-for="(skill,index) in skills"
      @click="$emit('onClick', {skillId: skill.id, skillIndex: index})"
      @mouseover="onPoint(skill.id)"
      :class="clickable ? 'clickable' : ''"
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

export default {
  data: function () {
    return {

    };
  },
  props: {
    isPlayer: Boolean,
    skills: Array,
    clickable: Boolean,
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
      this.$store.commit('guide/updateGuide', this.$store.state.masterdata.skills[skillId]?.description);
    },
    iconImagePath(skillId){
      if(!this.$store.state.masterdata?.skills[skillId]){
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
    .selected{
      background-color: $gray3;
      border: 1px solid $yellow;
    }
    .disabled{
      opacity: 0.5;
    }
  }
  .clickable{
    // ↑の .skill についてるborderがグローバルセッティングの .clickable についている border を打ち消してしまう
    // 今回は .clickable の方に勝ってほしいのでここで再定義する(ダサい...)
    border: 1px solid $gray1;
  }
}

.player_skill_list{
  justify-content: flex-start;
}

.enemy_skill_list{
  justify-content: flex-end;
}
</style>

<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
        .title
          | 強敵戦・準備
      .description
        | 強敵と戦います。
      .body
        .characters
          img.tirol(src="/images/battle/tirol.png")
          img.spica(src="/images/battle/spica.png")
        .enemy_character
          img.enemy(src="/images/battle/enemy.png")
        CardList.player_deck(
          :cards="dummyDeck"
          :right-side="false"
        )
        CardList.enemy_deck(
          :cards="dummyDeck"
          :right-side="true"
        )
        .enemy_list
        .status_area
        .player_rank
        .open_magic_window
        .switch_deck_type
        .player_magic_list
          MagicList(:isPlayer="true")
        .enemy_magic_list
          MagicList(:isPlayer="false")
        .battle_start.clickable(@click="startBattle")
          | 戦闘開始
</template>

<script lang="ts">
  import Constants from "./packs/constants.ts";
  import store from './packs/store.ts'
  import axios from 'axios'
  import ax from "./packs/axios_default_setting.ts";
  import MagicList from "./MagicList.vue";
  import CardList from "./CardList.vue";
  import Card from "./packs/quest/card";

  export default {
    components: {
      MagicList,
      CardList,
    },
    data: function () {
      return {
        selectingEnemyId: 1,
      };
    },
    store,
    mounted(){
    },
    computed: {
      dummyDeck(){
          const deck=[]
        for(let i=0;i<7;++i){
            deck.push(new Card(i, "test", 1, 2, 3, 4,));
        }
        return deck;
      }
    },
    methods: {
      startBattle(){
        this.$store.commit("battle/setEnemyId", this.selectingEnemyId);
        this.$store.commit("window/updateWindowShowState", {windowName: "battle", state: true})
      }
    },
  }
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";

  *{
    outline: 1px solid #79f850;
  }

  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }
  .body {
    .characters{
      position: absolute;
      bottom: $space + 70px;
      left: $space;
      .spica{
        position: absolute;
        bottom: 0;
        left: 0;
        width: 256px;
        height: 256px;
      }
      .tirol{
        position: absolute;
        bottom: 0;
        left: -50px;
        width: 256px;
        height: 256px;
      }
    }

    .enemy_character{
      position: absolute;
      bottom: $space + 70px;
      right: $space;
      .enemy{
        width: 256px;
        height: 256px;
      }
    }

    .player_deck{
      position: absolute;
      left: 200px;
      top: 100px;
      width: 220px;
      height: 310px;
      outline: 1px solid #79f850;
    }

    .enemy_deck{
      position: absolute;
      right: 200px;
      top: 100px;
      width: 220px;
      height: 310px;
      outline: 1px solid #79f850;
    }

    .enemy_list{
      position: absolute;
      right: $space;
      top: 100px;
      width: 200px;
      height: 200px;
    }

    .status_area{
      position: absolute;
      left: calc((100% - 250px) / 2);
      top: 300px;
      width: 250px;
      height: 100px;
    }

    .player_rank{
      position: absolute;
      left: $space;
      top: 100px;
      width: 200px;
      height: 100px;
    }

    .open_magic_window{
      position: absolute;
      left: 270px;
      bottom: 75px;
      width: 100px;
      height: 40px;
    }

    .switch_deck_type{
      position: absolute;
      left: 370px;
      top: 100px;
      width: 70px;
      height: 30px;
    }

    .player_magic_list{
      position: absolute;
      bottom: $thin_space;
      left: $thin_space;
    }
    .enemy_magic_list{
      position: absolute;
      bottom: $thin_space;
      right: $thin_space;
    }

    .battle_start{
      position: absolute;
      bottom: 80px;
      left: calc((100% - 150px) / 2);
      width: 150px;
      height: 50px;
      padding-top: (50px - $font-size-normal) / 2;
      line-height: 100%;
      text-align: center;
    }


  }
</style>

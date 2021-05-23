<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'battle_prepare', state: false})")
          .arrow
        .title(v-if="!isDailyQuest")
          | クエスト戦・準備
        .title(v-if="isDailyQuest")
          | デイリー討伐
      .description(v-if="!isDailyQuest")
        | クエスト対象の敵と戦います。初めて倒す敵の場合は報酬がもらえます。
      .description(v-if="isDailyQuest")
        | 毎日違う敵(0:00更新)と戦えます。敵の強さと一日の最大カケラ獲得量はダンジョンの解放度で決まります。
      .body
        .reward_status(v-if="isDailyQuest")
          .index
            | 本日のカケラ取得
          .value
            | {{todayRewardReceived}} / {{todayRewardLimit}}
        .characters
          img.tirol(src="/images/battle/characters/tirol_normal.png")
          img.spica(src="/images/battle/characters/spica_normal.png")
        transition(name="vertical-in")
          .enemy_character(:key="currentEnemy.image_name")
            img.enemy(:src="`/images/battle/characters/${currentEnemy.image_name || 'faily'}_normal.png`")
        .enemy_reward(@mouseover="$store.commit('guide/updateGuide', currentEnemyRewardTypeMessage)")
          .descri
            | 撃破報酬：
          img.icon(:src="`/images/ui/${currentEnemyRewardType}.png`")
          .count
            | × {{ currentEnemyReward.amount }}
          .aquired(v-if="won(currentEnemy.id)")
            | 獲得済み
        CardList.player_deck(
          :cards="currentPlayerCards"
          :right-side="false"
        )
        CardList.enemy_deck(
          :class="enemyDefWins ? 'win' : ''"
          :cards="enemyDeck"
          :right-side="true"
        )
        .enemy_list.scrollable
          .enemy.selectable.hoverable(v-for="enemy in enemyList" @click="selectEnemy(enemy.id)" :class="enemyListClass(enemy.id)")
            .name
              | {{enemy.is_boss ?  "★" : ""}}{{enemy.name}}
        .notifications
          | {{notificationText}}
        .status_area
          .status(@mouseover="$store.commit('guide/updateGuide', atkGuideMessage)")
            .player
              .main
                | {{playerAtkMainPart}}
              .sub
                | {{playerAtkSubPart}}
            .label
              .index
                | ATK
              .equality
                | {{atkEquality}}
            .enemy(:class="enemyAtkWins ? 'win' : ''")
              .main
                | {{enemyAtkMainPart}}
              .sub
                | {{enemyAtkSubPart}}
          .status(@mouseover="$store.commit('guide/updateGuide', defGuideMessage)")
            .player
              .main
                | {{playerDefMainPart}}
              .sub
                | {{playerDefSubPart}}
            .label
              .index
                | DEF
              .equality
                | {{defEquality}}
            .enemy(:class="enemyDefWins ? 'win' : ''")
              .main
                | {{enemyDefMainPart}}
              .sub
                | {{enemyDefSubPart}}
          .status
            .player
              | {{$store.state.user.quest_battle_parameters.power}}
            .label
              | 力威力
            .enemy
              | {{currentEnemy.power}}
          .status
            .player
              | {{$store.state.user.quest_battle_parameters.tech}}
            .label
              | 技威力
            .enemy
              | {{currentEnemy.tech}}
          .status
            .player
              | {{$store.state.user.quest_battle_parameters.special}}
            .label
              | SP威力
            .enemy
              | {{currentEnemy.special}}
          .status
            .player
              | {{$store.state.user.quest_battle_parameters.hp}}
            .label
              | HP
            .enemy(:class="enemyAtkWins ? 'win' : ''")
              | {{currentEnemy.hp}}
        .open_skill_window.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_skill', state: true})")
          | スキル選択
        .switch_deck_type
          .class_cards.selectable(@click="showsClassCards = true", :class="showsClassCards ? 'selected' : ''")
            | クラスカード
          .equip_cards.selectable(@click="showsClassCards = false", :class="showsClassCards ? '' : 'selected'")
            | 装備
        .player_skill_list
          SkillList(
            :isPlayer="true"
            :skills="$store.state.skill.skills.filter((x)=>x.is_equipped)"
            v-if="$store.state.skill.skills.filter((x)=>x.is_equipped).length > 0"
          )
          .blank_skill_notification(v-if="$store.state.skill.skills.length > 0 && $store.state.skill.skills.filter((x)=>x.is_equipped).length===0")
            | スキルは能力解放か、一部の敵の討伐で取得できます。
        .enemy_skill_list
          SkillList(:isPlayer="false", :skills="currentEnemy.skills")
        .battle_start.clickable(@click="startBattle")
          | 戦闘開始
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
          CardList,
      },
      data: function () {
          return {
              selectingEnemyId: 1,
              showsClassCards: false,
              enemyList: [],
              classCardsResponse: [],
              itemCardsResponse: [],
              wonEnemyIds: [],
              dailyQuestId: 999,
              todayRewardLimit: 0,
              todayRewardReceived: 0,
          };
      },
      store,
      mounted(){
          this.fetchEnemyList();
          this.fetchPlayerDeck();
          this.fetchPlayerSkills();
          this.fetchPlayerWonEnemies();
      },
      computed: {
          isDailyQuest(){
            return this.$store.state.quest.quest_id === this.dailyQuestId;
          },
          notificationText(){
            let text = "";
            if(this.$store.getters['user/hasEmptySlot']){
                text += "装備の空枠は[休憩]になる。\n";
            }
            if(this.enemyAtkWins){
                text += "力負けし有効打が入らずHP増加。\n";
            }
            if(this.enemyDefWins){
                text += "守りが甘く、カード値増加。\n";
            }
            return text;
          },
          currentEnemy(){
              return this.enemyList.find((x)=>x.id===this.selectingEnemyId) || {};
          },
          currentEnemyReward(){
              if(!this.currentEnemy?.rewards){
                  return {};
              }
              return this.currentEnemy?.rewards[0];
          },
          currentEnemyRewardType(){
              return this.currentEnemyReward?.giftable_type?.toLowerCase() || 'coin';
          },
          currentEnemyRewardTypeMessage(){
              let message = "";
              switch(this.currentEnemyRewardType){
                  case 'coin':
                      message = "コインがもらえる。";
                      break;
                  case 'star':
                      message = "星のカケラがもらえる。";
                      break;
                  case 'raidstar':
                      message = "星のカケラがもらえる。(一日の取得制限総量に制限あり)";
                      break;
                  case 'skill':
                      message = "新たなスキルを教えてもらえる。";
                      break;
                  case 'dungeon':
                      message = "新たなダンジョンが解放される。";
                      break;
                  case 'randomitem':
                      message = "ランダムな高ランクアイテムが手に入る。";
                      break;
                  default:
                      console.warn("undefined reward");
              }
              return message
          },
          enemyDeck(){
              let cards = this.currentEnemy?.cards || [];
              for(let i=0; i < cards.length; i++){
                  cards[i].id = i;
              }
              return cards.map((x)=>new Card(x.id, x.name, x.power, x.tech));
          },
          currentPlayerCards(){
              const cards = this.showsClassCards ? this.classCardsResponse : this.itemCardsResponse;
              return cards?.map((x)=>new Card(x.id, x.name, x.power, x.tech));
          },
          expBase(){
            const maxValue = Math.max(
              this.playerAtk,
              this.playerDef,
              this.enemyStrength,
            )
            const exp = Math.log10(maxValue);
            return Math.pow(10, exp >= 3 ? ( exp >= 6 ? 6 : 3 ) : 0);
          },
          playerAtk(){
            return this.$store.getters['equip_window/getTotalStrength']("atk", false);
          },
          playerDef(){
            return this.$store.getters['equip_window/getTotalStrength']("def", false);
          },
          playerAtkMainPart(){
            return Math.floor(this.playerAtk / this.expBase);
          },
          playerAtkSubPart(){
            const source = this.playerAtk;
            const structure = this.expBase;
            if(structure === 1){
              return " "
            }
            const baseString = ("000000" + (source - Math.floor(source / structure) * structure)).slice(-Math.log10(structure));
            return "," + baseString.replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
          },
          enemyAtkMainPart(){
            const source = this.currentEnemy.strength || 0;
            const structure = this.expBase;
            return Math.floor(source / structure);
          },
          enemyAtkSubPart(){
            const source = this.currentEnemy.strength || 0;
            const structure = this.expBase;
            if(structure === 1){
              return " "
            }
            const baseString = ("000000" + (source - Math.floor(source / structure) * structure)).slice(-Math.log10(structure));
            return "," + baseString.replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
          },
          playerDefMainPart(){
            const source = this.playerDef;
            const structure = this.expBase;
            return Math.floor(source / structure);
          },
          playerDefSubPart(){
            const source = this.playerDef;
            const structure = this.expBase;
            if(structure === 1){
              return " "
            }
            const baseString = ("000000" + (source - Math.floor(source / structure) * structure)).slice(-Math.log10(structure));
            return "," + baseString.replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
          },
          enemyDefMainPart(){
            const source = this.currentEnemy.strength || 0;
            const structure = this.expBase;
            return Math.floor(source / structure);
          },
          enemyDefSubPart(){
            const source = this.currentEnemy.strength || 0;
            const structure = this.expBase;
            if(structure === 1){
              return " "
            }
            const baseString = ("000000" + (source - Math.floor(source / structure) * structure)).slice(-Math.log10(structure));
            return "," + baseString.replace( /(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
          },
          enemyStrength(){
            return this.currentEnemy.strength || 0;
          },
          enemyAtkWins(){
            return this.playerAtk < this.enemyStrength;
          },
          enemyDefWins(){
            return this.playerDef < this.enemyStrength;
          },
          atkEquality(){
            if(this.playerAtk > this.enemyStrength){
              return ">";
            }
            if(this.playerAtk == this.enemyStrength){
              return "=";
            }
            if(this.playerAtk > this.enemyStrength * Constants.enemy.plusValueThreshold){
              return "<";
            }
            return "<<";
          },
          defEquality(){
            if(this.playerDef > this.enemyStrength){
              return ">";
            }
            if(this.playerDef == this.enemyStrength){
              return "=";
            }
            if(this.playerDef > this.enemyStrength * Constants.enemy.plusValueThreshold){
              return "<";
            }
            return "<<";
          },
          atkGuideMessage(){
            switch(this.atkEquality){
              case ">":
                return "【ATK優勢】相手よりも強い。補正なし。";
              case "=":
                return "【ATK同格】相手とちょうど一緒。補正なし。";
              case "<":
                return `【ATK劣勢】【 ${Math.floor(this.enemyStrength * Constants.enemy.plusValueThreshold)} < x < ${this.enemyStrength} 】相手よりもわずかに劣っている。敵HPが強化される。`;
              case "<<":
                return `【ATK格上】【 x < ${Math.floor(this.enemyStrength * Constants.enemy.plusValueThreshold)} 】相手のほうが圧倒的に強い。敵HPが大幅に強化される。`;
              default:
                return "";                
            }
          },
          defGuideMessage(){
            switch(this.defEquality){
              case ">":
                return "【DEF優勢】相手よりも強い。補正なし。";
              case "=":
                return "【DEF同格】相手とちょうど一緒。補正なし。";
              case "<":
                return `【DEF劣勢】【 ${Math.floor(this.enemyStrength * Constants.enemy.plusValueThreshold)} < x < ${this.enemyStrength} 】相手よりもわずかに劣っている。敵カードが強化される。`;
              case "<<":
                return `【DEF格上】【 x < ${Math.floor(this.enemyStrength * Constants.enemy.plusValueThreshold)} 】相手のほうが圧倒的に強い。敵カードが大幅に強化される。`;
              default:
                return "";                
            }
          },
      },
      methods: {
          selectEnemy(id){
              this.selectingEnemyId = id;
          },

          selectFirstAliveEnemy(){
            for(let enemy of this.enemyList){
                if(!this.won(enemy.id)){
                    this.selectEnemy(enemy.id);
                    return;
                }
            }
            this.selectEnemy(this.enemyList[this.enemyList.length - 1].id);
          },

          fetchEnemyList(){
            if(this.isDailyQuest){
              this.fetchEnemyListDaily();
            }
            else{
              this.fetchEnemyListNormal();
            }
          },

          fetchEnemyListDaily(){
              const path = `/enemies/daily.json`;
              const params = {};
              ax.get(path, { params: params})
                  .then((results) => {
                      console.log(results);
                      this.enemyList = results.data.enemies;
                      this.todayRewardLimit = results.data.today_reward_limit;
                      this.todayRewardReceived = results.data.today_reward_received;
                      this.selectFirstAliveEnemy();
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },

          fetchEnemyListNormal(){
              const path = `/enemies.json`;
              const params = {
                  quest_id: this.$store.state.quest.quest_id,
              };
              ax.get(path, { params: params})
                  .then((results) => {
                      console.log(results);
                      this.enemyList = results.data.enemies;
                      this.selectFirstAliveEnemy();
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
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
          fetchPlayerDeck(){
              const user_id = localStorage.user_id;
              const path = `/users/${user_id}/deck.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      this.classCardsResponse = results.data.class_cards;
                      this.itemCardsResponse = results.data.item_cards;
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },

          fetchPlayerWonEnemies(){
              const user_id = localStorage.user_id;
              const path = `/users/${user_id}/won_enemies.json`;
              ax.get(path)
                  .then((results) => {
                      console.log(results);
                      this.wonEnemyIds = results.data.won_enemies.map((x)=>x.enemy_id);
                  })
                  .catch((error) => {
                      console.warn(error.response);
                      console.warn("NG");
                  });
          },

          startBattle(){
              this.$store.commit("battle/setEnemyId", this.selectingEnemyId);
              this.$store.commit("battle/setIsDaily", this.isDailyQuest);
              this.$store.commit("window/updateWindowShowState", {windowName: "battle", state: true})
          },

          enemyListClass(enemyId){
              if(this.selectingEnemyId == enemyId){
                  return 'selected';
              }
              return this.won(enemyId) ? "disabled" : "";
          },

          won(enemyId){
              return this.wonEnemyIds.includes(enemyId);
          }
      },
  }
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";

  .reward_status{
    position: absolute;
    top: $space;
    right: $space;
    width: 300px;
    height: 100px;
    text-align: right;
    .value{
      font-size: $font-size-large;
    }
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
      animation: vertical-in;
      position: absolute;
      bottom: $space + 70px;
      right: $space;
      .enemy{
        width: 220px;
        height: 220px;
      }
    }

    .enemy_reward{
      position: absolute;
      bottom: $space + 70px;
      right: $space;
      width: 200px;
      height: 40px;
      background-color: $background_with_opacity;
      border-radius: $radius;
      padding: $thin_space;
      line-height: 105%;
      .descri, .icon, .count{
        display: inline-block;
      }
      .icon{
        width: $font-size-normal;
        height: $font-size-normal;
      }
    }

    .player_deck{
      position: absolute;
      left: 205px;
      top: 100px;
      width: 213px;
      height: 330px;
    }

    .enemy_deck{
      position: absolute;
      right: 190px;
      top: 100px;
      width: 213px;
      height: 330px;
      &.win{
        color: $yellow;
      }
    }

    .enemy_list{
      position: absolute;
      right: $space;
      top: 100px;
      width: 200px;
      height: 240px;
      .enemy{
        @include centering($height: 30px);
        margin: 2px;
        width: calc(100% - 6px);
        font-size: $font-size-mini;
        .name{
          padding-left: $thin_space;
          display: inline-block;
          text-align: left;
          width: 100%;
        }
      }
      .disabled{
        opacity: 0.5;
      }
    }

    .notifications{
      position: absolute;
      left: calc((100% - 220px) / 2);
      top: 100px;
      width: 220px;
      height: 20px;
      font-size: $font-size-mini;
      line-height: 170%;
      text-align: center;
      white-space: pre;
    }

    .status_area{
      position: absolute;
      left: calc((100% - 180px) / 2);
      top: 170px;
      width: 180px;
      height: 100px;
      .status{
        padding: $thin_space;
        width: 100%;
        display: flex;
        text-align: center;
        align-items: center;
        border-bottom: 1px solid $gray3;
        .player, .enemy{
          width: 35%;
          font-size: $font-size-large;
        }
        .label{
          width: 30%;
        }
        .main{
          line-height: 100%;
        }
        .sub{
          font-size: 12px;
          line-height: 100%;
        }
        .win{
          color: $yellow;
        }
      }
    }

    .open_skill_window{
      position: absolute;
      left: 230px;
      bottom: 75px;
      width: 170px;
      border-radius: $radius;
      @include centering($height: 30px);
    }

    .switch_deck_type{
      position: absolute;
      left: $space + 30px;
      top: $space + 110px;
      width: 140px;
      height: 56px;
      .class_cards, .equip_cards{
        width: 140px;
        height: 28px;
        padding-top: 6px;
        line-height: 100%;
        text-align: center;
      }
      .class_cards{
        border-radius: $radius $radius 0 0;
      }
      .equip_cards{
        border-radius: 0 0 $radius $radius;
      }
      .active{
        background-color: $gray3-opacity;
      }
    }

    .player_skill_list{
      position: absolute;
      bottom: $thin_space;
      left: $thin_space;
    }
    .enemy_skill_list{
      position: absolute;
      bottom: $thin_space;
      right: $thin_space;
    }

    .battle_start{
      position: absolute;
      bottom: 75px;
      left: calc((100% - 150px) / 2);
      width: 150px;
      @include centering($height: 50px);
    }
  }

  .vertical-in-enter-active {
    transition: all .3s;
  }
  .vertical-in-leave-active {
    transition: all .0s;
  }
  .vertical-in-enter{
    transform: translateY(-10px);
    opacity: 0.5;
  }
  .vertical-in-leave-to{
    opacity: 0;
  }
</style>

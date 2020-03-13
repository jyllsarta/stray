<template lang="pug">
  .menu(@click.right.prevent="removeLastEquip")
    .back(@click="closeWindow")
    .window.content
      .title_area
        .back_button(
          @click="closeWindow"
          @mouseover="$store.commit('guide/updateGuide', '編集を確定してメニューを閉じます。')",
        )
        .title
          | 装備
      .body
        .sub_chara
          img.sub_character_image(:src="'images/characters/' + $store.getters['equip_window/getSubCharacterName'] + '.png'")
        .chara
          img.character_image(:src="'images/characters/' + $store.getters['equip_window/getMainCharacterName'] + '.png'")
        .switch_character_button.clickable(
          @click="$store.commit('equip_window/switchMainCharacter')"
          @mouseover="$store.commit('guide/updateGuide', '装備を編集するキャラを交代します。')",
          )
          | 編集キャラ交代
        .reinforcements.block
          .label
            | 加護
          .reinforcement_list(v-if="false")
            // 一旦加護実装まで封印
            .reinforcement
              | 先制Lv2
          .no-reinforcement(v-else="false")
            .message
              | 加護がありません
        .sub_chara_status.block
          .label
            | {{$store.getters['equip_window/getSubCharacterJapaneseName']}}のステータス
          .status
            .param(v-for="param in ['atk', 'def']")
              span.current
                | {{param.toUpperCase()}}: {{$store.getters['equip_window/getCharacterStrength']($store.getters['equip_window/getSubCharacterId'], param, true)}}
              span.diff
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.getters['equip_window/getSubCharacterId'], param)}})
          .equips
            .equip(
              v-for="item in $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.getters['equip_window/getSubCharacterId'])"
              @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
              @mouseleave="$store.commit('equip_window/updateSelectingItemId', 0)"
            )
              | {{item.name}}
            // 空枠を埋める
            .equip(v-for="nilItem in (new Array(Constants.maxEquipCount - $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.getters['equip_window/getSubCharacterId']).length).fill(1))")
              | -
        .item_list_main.block
          .label
            | アイテム
          .misc
            .pager
              .button(@click="changePage(-1)")
                | ◀
              .state
                | ページ {{$store.state.equip_window.current_page}} / {{Math.ceil(Object.keys($store.state.user.items).length / Constants.itemsPerPage)}}
              .button(@click="changePage(1)")
                | ▶
            .sort
              .reverse_order(
                @click="$store.commit('equip_window/reverseItemSortOrder')"
                @mouseover="$store.commit('guide/updateGuide', 'クリックで昇順と降順を切り替えます。')",
              )
                | [{{$store.state.equip_window.current_sort_order === 1 ? '昇順' : '降順'}}]
              .change_order(@click="$store.commit('equip_window/switchItemSortLambda', 0)", @mouseover="$store.commit('guide/updateGuide', 'ソート順をID順に切り替えます。')",)
                | {{$store.state.equip_window.current_sort_id === 0 ? '★' : ''}}ID順
              .change_order(@click="$store.commit('equip_window/switchItemSortLambda', 1)", @mouseover="$store.commit('guide/updateGuide', 'ソート順を効果値順に切り替えます。')",)
                | {{$store.state.equip_window.current_sort_id === 1 ? '★' : ''}}効果値順
          .item_list
            .item(
              v-for="item in $store.getters['equip_window/getItemsWithPagerSorted']",
              @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
              @mouseleave="$store.commit('equip_window/updateSelectingItemId', 0)"
              @click="tryAttachEquip(item.id, $store.state.equip_window.main_character_id)"
              :class="$store.getters['equip_window/isAlreadyEquippedBySomeone'](item.id) ? 'disabled' : ''"
            )
              .category_icon
                | ◆
              .item_name
                | {{$store.getters['equip_window/getItemRarityIcon'](item.id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item.id)}}
              .value
                | {{$store.getters['equip_window/getItemEffectValue'](item.id)}}
            .item(v-for="nilItem in new Array(10 - $store.getters['equip_window/getItemsWithPager'].length).fill(1)")
              .category_icon
                | ◆
              .item_name
                | ？？？
              .value
                | -
        .detail.block
          .label
            | 詳細
          .item_name
            | {{currentItem ? currentItem.name : "-"}}
          .parameters
            .parameter
              | TOTAL {{$store.getters['equip_window/getItemEffectValue']($store.state.equip_window.selecting_item_id)}}
            .parameter(v-for="param in ['str', 'dex', 'def', 'agi']")
              | {{param.toUpperCase()}} {{currentItem ? currentItem.effectValueOf(param) : ''}}
          .flavor_text
            | {{currentItem ? currentItem.flavor_text : "-"}}
        .main_chara_equips.block
          .label_box
            .label
              | {{$store.getters['equip_window/getMainCharacterJapaneseName']}}のステータス
            .current_parameters_label
              | ステータス
            .this_item_label
              | 選択中の装備
            .to_status_label
              | 効果値
          .main
            .equips
              .equip(
                v-for="item in $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.state.equip_window.main_character_id)"
                @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
                @mouseleave="$store.commit('equip_window/updateSelectingItemId', 0)"
                @click="$store.commit('equip_window/removeEquip', {itemId: item.id, characterId: $store.state.equip_window.main_character_id})"
              )
                |  {{$store.getters['equip_window/getItemRarityIcon'](item.id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item.id)}}
              .equip(v-for="nilItem in (new Array(Constants.maxEquipCount - $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.state.equip_window.main_character_id).length).fill(1))")
                | -
            .current_parameters
              .status(v-for="param in ['str', 'dex', 'def', 'agi']")
                .label
                  | {{param.toUpperCase()}}
                .value
                  | {{$store.getters['equip_window/getCharacterParameter']($store.state.equip_window.main_character_id, param, true)}}
            .this_item
              // TODO: マイナス対応
              .status(v-for="param in ['str', 'dex', 'def', 'agi']")
                | {{currentItem ? withPlus(currentItem.effectValueOf(param)) : '-'}}
            .to_status
              .status
                | ATK: {{$store.getters['equip_window/getCharacterStrength']($store.state.equip_window.main_character_id, 'atk', true)}}
              .status_diff
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'atk')}})
              .status
                | DEF: {{$store.getters['equip_window/getCharacterStrength']($store.state.equip_window.main_character_id, 'def', true)}}
              .status_diff
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'def')}})
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
    };
  },
  store,
  mounted(){
    this.$store.commit("equip_window/initializeEquipWindow", this.$store.state.user.equips);
    this.$store.commit('guide/updateGuide', '装備メニューです。右クリックで装備を外せます。')
  },
  methods: {
    removeLastEquip(){
      const characterId = this.$store.state.equip_window.main_character_id;
      const item = this.$store.getters['equip_window/getCurrentEquipsByCharacterId'](characterId).pop();
      if(!item){
        return;
      }
      this.$store.commit('equip_window/removeEquip', {itemId: item.id, characterId: characterId})
    },
    tryAttachEquip(itemId, characterId){
      if(!this.$store.getters['equip_window/isAlreadyEquippedBySomeone'](itemId)){
        this.$store.commit('equip_window/attachEquip', {itemId: itemId, characterId: characterId})
      }
    },
    submit(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/equips/edit`;
      ax.post(
        path,
        {
          spica: this.$store.state.equip_window.draft.spica,
          tirol: this.$store.state.equip_window.draft.tirol,
        })
        .then((results) => {
          console.log(results);
          console.log("OK");
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    closeWindow(){
      this.submit();
      this.$store.commit('syncEquipDraft', this.$store.state.equip_window.draft);
      this.$store.commit('window/updateWindowShowState', {windowName: 'equip', state: false});
      this.$store.commit("addEventLog", {message: "装備を編集した！"});
    },
    withPlus(num){
      return num > 0 ? "+" + num : num;
    },
    changePage(delta){
      let page = this.$store.state.equip_window.current_page;
      page += delta;
      const maxPage = Math.ceil(Object.keys(this.$store.state.user.items).length / Constants.itemsPerPage);
      if(page > maxPage){
        page = maxPage;
      }
      if(page < 1){
        page = 1;
      }
      this.$store.commit("equip_window/changePage", page);
    }
  },
  computed: {
    currentItem(){
      return this.$store.getters['equip_window/getUserItem'](this.$store.state.equip_window.selecting_item_id);
    },
    Constants(){
      return Constants;
    },
  }
}
</script>


<style lang="scss" scoped>
  @import "stylesheets/global_setting";

  // 箱自体の配置
  // 頭がおかしくなりそうなんだけどこういうのの配置って通常どうなってるんです？

  $detail-width: 150px;
  $character-width: 200px;
  $character-height: 380px;
  $sub-character-width: 100px;
  $sub-character-height: 200px;
  $main-chara-equip-height: 170px;
  $item_list-main-width:400px;
  $reinforcement-list-height: 200px;

  .content{
    overflow: hidden;
  }

  // 通常のスタイル定義
  .body{
    .block{
      border-left: 1px solid $gray3;
      //border-radius: $radius;
    }

    .label{
      font-size: $font-size-normal;
      color: $accent-color;
      line-height: 100%;
    }
    .character_image{
      width: 220px;
      transform: scale(-1,1);
    }
    .sub_character_image{
      width: 160px;
    }

    .switch_character_button{
      position: absolute;
      top: 60px;
      left: $space;
      padding: $space;
    }

    .reinforcements{
      .reinforcement_list{
        display: flex;
        flex-direction: column;
        flex-wrap: wrap;
        height: $reinforcement-list-height - $font-size-large;
        padding: $thin_space;
        .reinforcement{
          margin: $thin_space;
          border-bottom: 1px solid $gray3;
          width: 45%;
          text-align: center;
          &::before{
            content: "◇";
          }
        }
      }
      .no-reinforcement{
        display: flex;
        height: $reinforcement-list-height - $font-size-large;
        justify-content: space-around;
        flex-direction: column;
        .message{
          font-size: $font-size-mini;
          width: 100%;
          height: $font-size-normal;
          line-height: 100%;
          text-align: center;
        }
      }
    }

    .sub_chara_status{
      font-size: $font-size-mini;
      padding-bottom: $space;
      .status{
        padding: $thin_space;
      }
      .equips{
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        .equip{
          padding: 2px;
          font-size: $font-size-mini;
        }
      }
    }

    .item_list_main{
      .misc{
        height: 50px;
        border-bottom: 1px solid $gray3;
        padding: $space;
        display: flex;
        .pager{
          display: flex;
          padding: $space;
        }
        .sort{
          display: flex;
          div{
            padding: $space;
          }
        }
      }
      .item_list{
        width: 100%;
        display: flex;
        flex-direction: column;
        height: calc(100% - 50px - #{$font-size-normal});
        justify-content: space-around;
        padding: $thin_space;
        .item{
          padding: 2px;
          display: flex;
          flex-direction: row;
          line-height: 100%;
          .category_icon{
            width: 5%;
          }
          .item_name{
            width: 75%;
          }
          .value{
            width: 20%;
          }
        }
      }
    }
    .disabled{
      opacity: 0.4;
    }

    .detail{
      font-size: $font-size-mini;
      .item_name{
        padding: $thin_space;
        height: 50px;
      }
      .parameters{
        padding: $thin_space;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        height: 100px;
        .parameter{
          width: 100%;
          text-align: right;
        }
      }
      .flavor_text{
        line-height: 115%;
        padding: $thin_space;
      }
    }

    .main_chara_equips{
      .label_box{
        display: flex;
        flex-direction: row;
        color: $accent-color;
        align-content: flex-end;
        .label{
          width: 43%;
        }
        .current_parameters_label{
          width: 17%;
        }
        .this_item_label{
          width: 17%;
        }
        .to_status_label{
          width: 17%;
        }
      }
      .main{
        display: flex;
        flex-direction: row;
        height: calc(100% - #{$font-size-large});
        .equips{
          width: 43%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .equip{
            padding: 2px;
            &:nth-child(1){
              padding-left: 8px;
            }
            &:nth-child(2){
              padding-left: 16px;
            }
            &:nth-child(3){
              padding-left: 24px;
            }
            &:nth-child(4){
              padding-left: 32px;
            }
          }
        }
        .current_parameters{
          width: 17%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .status{
            padding: 2px;
            .label{
              display: inline-block;
              width: 30%;
            }
            .value{
              display: inline-block;
              width: 70%;
            }
          }
        }
        .this_item{
          width: 19%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .status{
            font-size: $font-size-mini;
            padding-left: $space;
          }
        }
        .to_status{
          width: 17%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .status_diff{
            font-size: $font-size-mini;
            text-align: right;
          }
        }
      }
    }
  }

  .body{
    .chara{
      position: absolute;
      bottom: $thin_space;
      left: -50px;
      width: $character-width - $thin_space * 2;
      height: $character-height;
    }
    .sub_chara{
      position: absolute;
      bottom: 250px;
      left: 100px;
      width: $sub-character-width;
      height: $sub-character-height;
    }
    .reinforcements{
      position: absolute;
      top: $thin_space;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: $reinforcement-list-height;
    }
    .sub_chara_status{
      position: absolute;
      top: $reinforcement-list-height + $thin_space * 2;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: calc(100% - #{$main-chara-equip-height} - #{$reinforcement-list-height} - #{$thin_space * 5});
    }
    .item_list_main{
      position: absolute;
      top: $thin_space;
      right: $detail-width + $thin_space * 2;
      width: $item-list-main-width;
      height: calc(100% - #{$main-chara-equip-height} - #{$thin_space * 3});
    }
    .detail{
      position: absolute;
      top: $thin_space;
      right: $thin_space;
      width: $detail-width;
      height: calc(100% - #{$main-chara-equip-height} - #{$thin_space * 3});
    }
    .main_chara_equips{
      position: absolute;
      bottom: $thin_space;
      right: $thin_space;
      width: calc(100% - #{$character-width} - #{$thin_space});
      height: $main-chara-equip-height;
    }
  }
</style>

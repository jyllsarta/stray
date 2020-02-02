<template lang="pug">
  .menu
    .back(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
    .window.content
      .title_area
        .back_button(@click="$store.commit('updateWindowShowState', {windowName: 'equip', state: false})")
        .title
          | 装備
      .body
        .sub_chara
          img.sub_character_image(:src="'images/characters/' + $store.getters.getSubCharacterName + '.png'")
        .chara
          img.character_image(:src="'images/characters/' + $store.getters.getMainCharacterName + '.png'")
        .switch_character_button.clickable(@click="$store.commit('switchMainCharacter')")
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
            | {{$store.getters.getSubCharacterJapaneseName}}のステータス
          .status
            .atk
              span.current
                | ATK: 351287952
              span.diff
                | (+987987987)
            .def
              span.current
                | DEF: 351287952
              span.diff
                | (+987987987)
          .equips
            .equip(v-for="item in $store.getters.getCurrentEquipsByCharacterId($store.getters.getSubCharacterId)")
              | {{item.name}}
            // 空枠を埋める
            .equip(v-for="nilItem in (new Array(4 - $store.getters.getCurrentEquipsByCharacterId($store.getters.getSubCharacterId).length).fill(1))")
              | -
        .item_list_main.block
          .label
            | アイテム
          .misc
            | ソート順とかを置くところ
          .item_list
            .item(
              v-for="item in $store.getters.getItems", @mouseover="$store.commit('updateSelectingItemId', item.id)"
              @click="tryAttachEquip(item.id, $store.state.ui.equip_window.main_character_id)"
              :class="$store.getters.isAlreadyEquippedBySomeone(item.id) ? 'disabled' : ''"
              )
              .category_icon
                | ◆
              .item_name
                | {{$store.getters.getItemRarityIcon(item.id)}}{{item.name}}+{{item.rank}}
              .value
                | {{$store.getters.getItemEffectValue(item.id)}}
            .item(v-for="nilItem in new Array(10 - $store.getters.getItems.length).fill(1)")
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
            | {{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).name}}
          .parameters
            .parameter
              | TOTAL {{$store.getters.getItemEffectValue($store.state.ui.equip_window.selecting_item_id)}}
            .parameter
              | STR {{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).str}}
            .parameter
              | DEX {{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).dex}}
            .parameter
              | DEF {{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).def}}
            .parameter
              | AGI {{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).agi}}
          .flavor_text
            | {{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).flavor_text}}
        .main_chara_equips.block
          .label_box
            .label
              | {{$store.getters.getMainCharacterJapaneseName}}のステータス
            .current_parameters_label
              | ステータス
            .this_item_label
              | 選択中の装備
            .to_status_label
              | 効果値
          .main
            .equips
              .equip(
                v-for="item in $store.getters.getCurrentEquipsByCharacterId($store.state.ui.equip_window.main_character_id)"
                @click="$store.commit('removeEquip', {itemId: item.id, characterId: $store.state.ui.equip_window.main_character_id})"
                )
                |  {{$store.getters.getItemRarityIcon(item.id)}}{{item.name}}+{{$store.getters.getUserItemRank(item.id)}}
              .equip(v-for="nilItem in (new Array(4 - $store.getters.getCurrentEquipsByCharacterId($store.state.ui.equip_window.main_character_id).length).fill(1))")
                | -
            .current_parameters
              .status
                | STR 987654321
              .status
                | DEX 987654321
              .status
                | RES 987654321
              .status
                | AGI 987654321
            .this_item
              .status
                // TODO: マイナス対応
                | +{{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).str}}
              .status
                | +{{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).dex}}
              .status
                | +{{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).def}}
              .status
                | +{{$store.getters.getUserItem($store.state.ui.equip_window.selecting_item_id).agi}}
            .to_status
              .status
                | ATK: 987654321
              .status_diff
                | (+987654321)
              .status
                | DEF: 987654321
              .status_diff
                | (+987654321)
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'

export default {
  data: function () {
    return {
    };
  },
  store,
  mounted(){
  },
  methods: {
    tryAttachEquip(itemId, characterId){
      if(!this.$store.getters.isAlreadyEquippedBySomeone(itemId)){
        this.$store.commit('attachEquip', {itemId: itemId, characterId: characterId})
      }
    },
  },
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
          text-align: right;
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

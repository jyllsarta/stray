<template lang="pug">
  .menu(@click.right.prevent="removeLastEquip")
    .back(@click="closeWindow")
    .window.content
      .title_area
        .back_button.clickable(
          @click="closeWindow"
          @mouseover="$store.commit('guide/updateGuide', '編集を確定してメニューを閉じます。')",
        )
        .title
          | 装備
      .body
        .sub_chara(:style="{transform: `translateY(${sub_character_position}px)`}")
          img.sub_character_image(:src="'images/characters/' + $store.getters['equip_window/getSubCharacterName'] + '.png'")
        .chara(:style="{transform: `translateY(${main_character_position}px)`}")
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
              span.diff(:class="[deltaClass($store.getters['equip_window/getCharacterStrengthDiff']($store.getters['equip_window/getSubCharacterId'], param))]")
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.getters['equip_window/getSubCharacterId'], param)}})
          .equips
            .equip(
              v-for="item in $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.getters['equip_window/getSubCharacterId'])"
              @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
              @mouseleave="$store.commit('equip_window/updateSelectingItemId', 0)"
              :class="[rarityClass(item)]"
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
              :class="[{ disabled: isAlreadyEquipped(item) }]"
            )
              .param_area
                .item_name(:class="[rarityClass(item)]")
                  | {{$store.getters['equip_window/getItemRarityIcon'](item.id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item.id)}}
                .value
                  | {{$store.getters['equip_window/getItemEffectValue'](item.id)}}
              .bar_area
                .bar(
                  v-for="param in ['str', 'dex', 'def', 'agi']"
                  :class="param"
                  :style="{width: cropWidth( 100 * (1/4) * relativeEffectivenessRatio(item.effectValueOf(param)) + withPercent(item.effectValueOf(param)))}"
                  )
            .item(
              v-for="nilItem in new Array(Constants.itemsPerPage - $store.getters['equip_window/getItemsWithPager'].length).fill(1)"
              :class="[{ disabled: true }]"
              )
              .param_area
                .item_name
                  | ？？？
                .value
                  | -
              .bar_area
                .bar(
                  v-for="param in ['str', 'dex', 'def', 'agi']"
                  :class="param"
                  :style="{width: 0}"
                )
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
            .kos
              img.ko.upper(src="images/ui/ko.png")
              img.ko.downer(src="images/ui/ko.png")
            .equips
              .equip.item(
                v-for="item in $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.state.equip_window.main_character_id)"
                @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
                @mouseleave="$store.commit('equip_window/updateSelectingItemId', 0)"
                @click="$store.commit('equip_window/removeEquip', {itemId: item.id, characterId: $store.state.equip_window.main_character_id})"
              )
                .param_area
                  .item_name(:class="[rarityClass(item)]")
                    | {{$store.getters['equip_window/getItemRarityIcon'](item.id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item.id)}}
                .bar_area
                  .bar(
                    v-for="param in ['str', 'dex', 'def', 'agi']"
                    :class="param"
                    :style="{width: cropWidth( 100 * (1/4) * relativeEffectivenessRatio(item.effectValueOf(param)) + withPercent(item.effectValueOf(param)))}"
                  )
              .equip(v-for="nilItem in (new Array(Constants.maxEquipCount - $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.state.equip_window.main_character_id).length).fill(1))")
                | -
            .current_parameters
              .status(v-for="param in ['str', 'dex', 'def', 'agi']")
                .param_area
                  .label(:class="param")
                    | {{param.toUpperCase()}}
                  .value
                    | {{$store.getters['equip_window/getCharacterParameter']($store.state.equip_window.main_character_id, param, true)}}
                .bar_area
                  .bar(
                    :class="param"
                    :style="{width: barWidthPercent(param)}"
                  )
            .this_item
              .status(
                v-for="param in ['str', 'dex', 'def', 'agi']"
                :class="[currentItem ? deltaClass(currentItem.effectValueOf(param)) : '']"
                )
                .param
                  | {{currentItem ? withPlus(currentItem.effectValueOf(param)) : '-'}}
                .bar_area
                  .bar(
                    :class="param"
                    :style="{width: currentItem ? cropWidth(100 * relativeEffectivenessRatio(currentItem.effectValueOf(param)) + withPercent(currentItem.effectValueOf(param)) ) : 0}"
                  )
            .to_status
              .status
                .param_area
                  .param
                    | ATK: {{$store.getters['equip_window/getCharacterStrength']($store.state.equip_window.main_character_id, 'atk', true)}}
                .bar_area
                  .bar.plus(
                    :style="{width: atkBar()}"
                  )
              .status_diff(:class="[deltaClass($store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'atk'))]")
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'atk')}})
              .status
                .param_area
                  .param
                    | DEF: {{$store.getters['equip_window/getCharacterStrength']($store.state.equip_window.main_character_id, 'def', true)}}
                .bar_area
                  .bar.minus(
                    :style="{width: defBar()}"
                  )
              .status_diff(:class="[deltaClass($store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'def'))]")
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'def')}})
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      move_character_handle: 0,
      sub_character_position: 0,
      main_character_position: 0,
    };
  },
  store,
  mounted(){
    this.$store.commit("equip_window/initializeEquipWindow", this.$store.state.user.equips);
    this.$store.commit('guide/updateGuide', '装備メニューです。右クリックで装備を外せます。');
    this.moveCharacter();
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
      this.$store.commit('user/syncEquipDraft', this.$store.state.equip_window.draft);
      this.$store.commit('window/updateWindowShowState', {windowName: 'equip', state: false});
      this.$store.commit("event/addEventLog", {message: "装備を編集した！"});
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
    },
    moveCharacter(){
      const now = new Date().getTime();
      this.main_character_position = Math.sin(now / 2000) * 7;
      this.sub_character_position = Math.sin(now / 2000 + 1) * 4;
      this.move_character_handle = requestAnimationFrame(this.moveCharacter);
    },
    isAlreadyEquipped(item){
      return this.$store.getters['equip_window/isAlreadyEquippedBySomeone'](item.id);
    },
    rarityClass(item){
      return `rarity${item.rarity}`;
    },
    deltaClass(delta){
      if(delta === 0){
        return "";
      }
      return delta > 0 ? 'plus' : 'minus';
    },
    relativeEffectivenessRatio(param){
      // TODO: ここの /4 は完全にUI横幅調整のためのものなので、レベデザ次第で修正していく
      return param / 4 / this.$store.getters['user/currentStandardParameter'];
    },
    cropWidth(param){
      if(param < 0){
        return 0;
      }
      if(param > 200){
        return 200;
      }
      return param;
    },
    withPercent(param){
      return param <= 0 ? '' : '%';
    },
    barWidthPercent(param){
      const value = this.$store.getters['equip_window/getCharacterParameter'](this.$store.state.equip_window.main_character_id, param, true);
      // 基準パラメータの2倍あったらwidth:100%にしたいので 1/2 を係数にかけてる
      return this.cropWidth(100 * (1/2) * this.relativeEffectivenessRatio(value)) + this.withPercent(value);
    },
    // atk, def は他パラメータの倍必要なので 1/4
    atkBar(){
      const value = this.$store.getters['equip_window/getCharacterStrength'](this.$store.state.equip_window.main_character_id, 'atk', true)
      return this.cropWidth(100 * (1/4) * this.relativeEffectivenessRatio(value)) + this.withPercent(value);
    },
    defBar(){
      const value = this.$store.getters['equip_window/getCharacterStrength'](this.$store.state.equip_window.main_character_id, 'def', true)
      return this.cropWidth(100 * (1/4) * this.relativeEffectivenessRatio(value)) + this.withPercent(value);
    }
  },
  beforeDestroy(){
    cancelAnimationFrame(this.move_character_handle);
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
      background-color: $background_with_opacity;
      opacity: $opacity;
      border-radius: $radius;
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

    .str{
      color: $str;
    }
    .dex{
      color: $dex;
    }
    .def{
      color: $def;
    }
    .agi{
      color: $agi;
    }

    .bar_area{
      width: 80%;
      height: 1px;
      display: flex;
      opacity: 0.9;
      .bar{
        width: 20%;
      }
      .str{
        background-color: $str;
      }
      .dex{
        background-color: $dex;
      }
      .def{
        background-color: $def;
      }
      .agi{
        background-color: $agi;
      }
      .plus{
        background-color: $plus;
      }
      .minus{
        background-color: $minus;
      }
    }

    .rarity1{
      color: $rarity1;
    }
    .rarity2{
      color: $rarity2;
    }
    .rarity3{
      color: $rarity3;
    }
    .rarity4{
      color: $rarity4;
    }
    .rarity5{
      color: $rarity5;
    }

    .plus{
      color: $plus;
    }
    .minus{
      color: $minus;
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

    .item{
      padding: $thin_space;
      .param_area{
        display: flex;
        flex-direction: row;
        line-height: 110%;
        .item_name{
          width: 80%;
        }
        .value{
          width: 20%;
        }
      }
      &:hover{
        filter: brightness(120%);
        background-color: $gray3;
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
        padding: $thin_space;
        overflow-y: scroll;
        &::-webkit-scrollbar{
          width: 10px;
        }
        &::-webkit-scrollbar-track{
          background: transparent;
          border: none;
          border-radius: $radius;
          box-shadow: inset 0 0 2px #777;
        }
        &::-webkit-scrollbar-thumb{
          background: $gray2;
          border-radius: $radius;
          box-shadow: none;
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
        .kos{
          position: absolute;
          .ko{
            position: absolute;
            width: 64px;
            opacity: 0.7;
          }
          .upper{
            top: 5px;
            left: 565px;

          }
          .downer{
            top: 75px;
            left: 565px;
          }
        }
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
            &:hover{
              filter: brightness(120%);
              background-color: $gray3;
            }
          }
        }
        .current_parameters{
          width: 20%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .status{
            padding: 2px;
            .param_area{
              .label{
                display: inline-block;
                width: 30%;
              }
              .value{
                display: inline-block;
                width: 70%;
              }
            }
            .bar_area{
              width: 100%;
              height: 1px;
              .bar{
                width: 100%;
                height: 1px;
              }
            }
          }
        }
        .this_item{
          width: 20%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .status{
            .param{
              padding-left: $space;
            }
            .bar_area{
              height: 1px;
              width: 50%;
              .bar{
                width: 100%;
                height: 1px;
              }
            }
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
          .bar_area{
            width: 100%;
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

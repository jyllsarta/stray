<template lang="pug">
  .menu(@click.right.prevent="removeLastEquip")
    .back(@click="closeWindow")
    .window.content
      .title_area
        .back_button.clickable(
          @click="closeWindow"
          @mouseover="$store.commit('guide/updateGuide', '編集を確定してメニューを閉じます。')",
        )
          .arrow
        .title
          | 装備
      .body
        .sub_chara(:style="{transform: `translateY(${sub_character_position}px)`}", :key="$store.state.equip_window.main_character_id")
          img.sub_character_image(
            :src="'images/characters/' + $store.getters['equip_window/getSubCharacterName'] + '.png'"
            @click="$store.commit('equip_window/switchMainCharacter')"
          )
        // key被り回避のためのハック用 +1
        .chara(:style="{transform: `translateY(${main_character_position}px)`}", :key="$store.state.equip_window.main_character_id + 1")
          img.character_image(
            :src="'images/characters/' + $store.getters['equip_window/getMainCharacterName'] + '.png'"
            @click="$store.commit('equip_window/switchMainCharacter')"
          )
        .switch_character_button.clickable(
          @click="$store.commit('equip_window/switchMainCharacter')"
          @mouseover="$store.commit('guide/updateGuide', '装備を編集するキャラを交代します。')",
        )
          | 編集キャラ交代
        .total_chara_status.block
          .label.topic_medium
            | 合計ステータス
          .status
            .param(v-for="param in ['atk', 'def']")
              span.current
                | {{param.toUpperCase()}}: {{$store.getters['equip_window/getTotalStrength'](param, true)}}
              span.diff(
                :class="[ deltaClass($store.getters['equip_window/getTotalStrengthDiff'](param)) ]"
              )
                | ({{$store.getters['equip_window/getTotalStrengthDiff'](param)}})
        .sub_chara_status.block
          .label.topic_medium
            | {{$store.getters['equip_window/getSubCharacterJapaneseName']}}のステータス
          .status
            .param(v-for="param in ['atk', 'def']")
              span.current
                | {{param.toUpperCase()}}: {{$store.getters['equip_window/getCharacterStrength']($store.getters['equip_window/getSubCharacterId'], param, true)}}
              span.diff(:class="[deltaClass($store.getters['equip_window/getCharacterStrengthDiff']($store.getters['equip_window/getSubCharacterId'], param))]")
                | ({{$store.getters['equip_window/getCharacterStrengthDiff']($store.getters['equip_window/getSubCharacterId'], param)}})
          .equips
            .equip.character_equip(
              v-for="item in $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.getters['equip_window/getSubCharacterId'])"
              @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
              :class="[rarityClass(item)]"
            )
              .param
                | {{$store.getters['equip_window/getItemRarityIcon'](item.id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item.id)}}
              .bar_area
                .bar(
                  v-for="param in ['str', 'dex', 'def', 'agi']"
                  :class="param"
                  :style="{width: cropWidth( 100 * (1/4) * relativeEffectivenessRatio(item.effectValueOf(param)) + withPercent(item.effectValueOf(param)))}"
                  )
            // 空枠を埋める
            .equip.character_equip(v-for="nilItem in (new Array(Constants.maxEquipCount - $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.getters['equip_window/getSubCharacterId']).length).fill(1))")
              .param
                | -
              .bar_area
                .bar
        .item_list_main.block
          .misc_area
            .label_block
              .label.topic_medium
                | アイテム
            .misc
              .pager_button(@click="changePage(-1)")
                | ◀
              .state
                | {{$store.state.equip_window.current_page}} / {{Math.ceil(Object.keys($store.state.user.items).length / Constants.itemsPerPage)}}
              .pager_button(@click="changePage(1)")
                | ▶
              .order.clickable(@mouseover="$store.commit('guide/updateGuide', 'クリックでソート順切り替えができます。')", @click="toggleSelectOrderWindow")
                | {{$store.getters['equip_window/getCurrentSortName']}}
              transition(name="open_window")
                .select_order(v-if="showing_select_order_window")
                  .close(@click="toggleSelectOrderWindow")
                  .in_window.window
                    .order.clickable(v-for="i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]", @click="onClickChangeSortLambdaButton(i)")
                      | {{$store.getters['equip_window/sortLambdas'](i).name}}
          .item_list.scrollable(ref="item_list")
            .item.hoverable(
              v-for="item in $store.getters['equip_window/getItemsWithPagerSorted']",
              @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
              @click="tryAttachEquip(item.id, $store.state.equip_window.main_character_id)"
            )
              .param_area
                .param(:class="[{ disabled: isAlreadyEquipped(item) }]")
                  .item_name(:class="[rarityClass(item)]")
                    | {{$store.getters['equip_window/getItemRarityIcon'](item.id)}}{{item.name}}{{$store.getters['equip_window/getUserItemRankTextForDisplay'](item.id)}}
                  // 力+技順を特別扱いする
                  .value(v-if="$store.state.equip_window.current_sort_id === 7")
                    | {{item.power()}} / {{item.tech()}}
                  .value(v-if="$store.state.equip_window.current_sort_id !== 7")
                    | {{$store.getters['equip_window/getCurrentSortKey'].lambda(item)}}
                .go_to_detail.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: true})")
                  | ＊
              .bar_area
                .bar(
                  v-for="param in ['str', 'dex', 'def', 'agi']"
                  :class="param"
                  :style="{width: cropWidth( 100 * (1/4) * relativeEffectivenessRatio(item.effectValueOf(param)) + withPercent(item.effectValueOf(param)))}"
                  )
            .item(v-for="nilItem in new Array(Constants.itemsPerPage - $store.getters['equip_window/getItemsWithPager'].length).fill(1)")
              .param_area(:class="[{ disabled: true }]")
                .param
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
          .label.topic_medium
            | 詳細
          .item_name
            | {{currentItem ? currentItem.name : "-"}}
          .parameters
            .parameter
              .index
                | RANK
              .value
                | {{currentItem ? currentItem.rank + currentItem.base_rank  : ''}}
            .parameter
              .index
                | TOTAL
              .value
                | {{$store.getters['equip_window/getItemEffectValue']($store.state.equip_window.selecting_item_id)}}
            .parameter(v-for="param in ['str', 'dex', 'def', 'agi']")
              .index(:class="param")
                | {{param.toUpperCase()}}
              .value
                | {{currentItem ? currentItem.effectValueOf(param) : ''}}
            .parameter
              .index
                span.power
                  | 力
                span.sep
                  | /
                span.tech
                  | 技
              .value
                | {{currentItem ? `${currentItem.power()} / ${currentItem.tech()}` : ''}}
          .flavor_text
            | {{currentItem ? currentItem.flavor_text : "-"}}
          .open_detail_window.clickable(
            v-if="currentItem"
            @click="$store.commit('window/updateWindowShowState', {windowName: 'equip_detail', state: true})"
            )
            | 詳細
        .main_chara_equips.block
          .label_box
            .label
              .topic_medium
                | {{$store.getters['equip_window/getMainCharacterJapaneseName']}}のステータス
            .current_parameters_label
              .topic_medium
                | ステータス
            .this_item_label
              .topic_medium
                | 選択中の装備
            .to_status_label
              .topic_medium
                | 効果値
          .main
            .kos
              img.ko.upper(src="images/ui/ko.png")
              img.ko.downer(src="images/ui/ko.png")
            .around_block
              | 周辺の敵ATK:{{aroundEnemyAtk}}
            .equips
              .equip.character_equip.hoverable.item(
                v-for="item in $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.state.equip_window.main_character_id)"
                @mouseenter="$store.commit('equip_window/updateSelectingItemId', item.id)"
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
              .equip.character_equip(v-for="nilItem in (new Array(Constants.maxEquipCount - $store.getters['equip_window/getCurrentEquipsByCharacterId']($store.state.equip_window.main_character_id).length).fill(1))")
                | -
            .current_parameters
              .status(v-for="param in ['str', 'dex', 'def', 'agi']")
                .param_area
                  .label(:class="param")
                    | {{param.toUpperCase()}}
                  .value
                    NumeratableNumber(:number="$store.getters['equip_window/getCharacterParameter']($store.state.equip_window.main_character_id, param, true)", :speed="0.6")
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
                    .text
                      | ATK:
                    NumeratableNumber(:number="$store.getters['equip_window/getCharacterStrength']($store.state.equip_window.main_character_id, 'atk', true)", :speed="0.6")
                .bar_area
                  .bar.plus(
                    :style="{width: atkBar()}"
                  )
              .status_diff(:class="[deltaClass($store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'atk'))]")
                NumeratableNumber(:number="$store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'atk')", :speed="0.6")
              .status
                .param_area
                  .param
                    .text
                      | DEF:
                    NumeratableNumber(:number="$store.getters['equip_window/getCharacterStrength']($store.state.equip_window.main_character_id, 'def', true)", :speed="0.6")
                .bar_area
                  .bar.minus(
                    :style="{width: defBar()}"
                  )
              .status_diff(:class="[deltaClass($store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'def'))]")
                NumeratableNumber(:number="$store.getters['equip_window/getCharacterStrengthDiff']($store.state.equip_window.main_character_id, 'def')", :speed="0.6")
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import ax from "./packs/axios_default_setting.ts";
import NumeratableNumber from "./NumeratableNumber.vue";

export default {
  components: {
    NumeratableNumber
  },
  data: function () {
    return {
      move_character_handle: 0,
      sub_character_position: 0,
      main_character_position: 0,
      showing_select_order_window: false,
    };
  },
  store,
  mounted(){
    this.$store.commit("equip_window/initializeEquipWindow", this.$store.state.user.equips);
    this.$store.commit('guide/updateGuide', '装備メニューです。右クリックで装備を外せます。');
    this.moveCharacter();
  },
  methods: {
    scrollToTop(){
      this.$refs.item_list.scrollTo(0, 0);
    },
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
          this.$store.dispatch("achievement/fetchAchievementCache");
          this.$store.dispatch("achievement/fetchAchievements");
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    closeWindow(){
      this.submit();
      this.$store.commit('equip_window/syncInitialToDraft');
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
      this.scrollToTop();
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
      const standard = Math.max(this.$store.getters['equip_window/getStrongestUserItem'].effectValue);
      return param / standard * 4; // 4パラメータ分の合計値との比較なので*4で比が一致する
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
      // 基準パラメータの4倍あったらwidth:100%にしたいので 1/4 を係数にかけてる
      return this.cropWidth(100 * (1/4) * this.relativeEffectivenessRatio(value)) + this.withPercent(value);
    },
    // atk, def は他パラメータの倍必要なので 1/4
    atkBar(){
      const value = this.$store.getters['equip_window/getCharacterStrength'](this.$store.state.equip_window.main_character_id, 'atk', true)
      return this.cropWidth(100 * (1/4) * this.relativeEffectivenessRatio(value)) + this.withPercent(value);
    },
    defBar(){
      const value = this.$store.getters['equip_window/getCharacterStrength'](this.$store.state.equip_window.main_character_id, 'def', true)
      return this.cropWidth(100 * (1/4) * this.relativeEffectivenessRatio(value)) + this.withPercent(value);
    },
    toggleSelectOrderWindow(){
      this.showing_select_order_window = !this.showing_select_order_window;
    },
    onClickChangeSortLambdaButton(id){
      this.showing_select_order_window = false;
      this.$store.commit('equip_window/switchItemSortLambda',  id)
      this.scrollToTop();
    },
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
    aroundEnemyAtk(){
      return this.$store.getters['user/aroundEnemyAtk'];
    },
    aroundEnemyRank(){
      return this.$store.getters['user/aroundEnemyRank'];
    },
  }
}
</script>


<style lang="scss" scoped>
  @import "stylesheets/global_setting";

  // 箱自体の配置
  // 頭がおかしくなりそうなんだけどこういうのの配置って通常どうなってるんです？

  $detail-width: 180px;
  $character-width: 170px;
  $character-height: 380px;
  $sub-character-width: 100px;
  $sub-character-height: 200px;
  $main-chara-equip-height: 170px;
  $item_list-main-width:400px;

  .content{
    overflow: hidden;
  }

  // 通常のスタイル定義
  .body{
    .character_image{
      width: 220px;
      transform: scale(-1,1);
    }
    .sub_character_image{
      width: 160px;
    }

    .chara {
      animation: main-character-animation 2s cubic-bezier(0,1.1,0,.98) 0s;
      cursor: pointer;
    }
    @keyframes main-character-animation {
      0% {
        transform: translateX(40px);
        opacity: 0.5;
      }
    }
    .sub_chara {
      animation: sub-character-animation 2s cubic-bezier(0,1.1,0,.98) 0s;
      cursor: pointer;
    }
    @keyframes sub-character-animation {
      0% {
        transform: translateX(-40px);
        opacity: 0.5;
      }
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
    .power{
      color: $plus;
    }
    .tech{
      color: $minus;
    }

    .bar_area{
      width: 89%;
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

    .total_chara_status{
      @include checker-background;
      font-size: $font-size-mini;
      padding-bottom: $thin_space;
      padding-top: $thin_space;
      .label{
        font-size: $font-size-normal;
        display: inline-block;
      }
      .status{
        padding: $thin_space;
        .param{
          padding: $space;
          font-size: $font-size-normal;
        }
      }
    }

    .sub_chara_status{
      @include checker-background;
      font-size: $font-size-mini;
      padding-bottom: $thin_space;
      padding-top: $thin_space;
      .label{
        font-size: $font-size-normal;
        display: inline-block;
      }
      .status{
        padding: $thin_space;
        .param{
          padding: $space;
          font-size: $font-size-normal;
        }
      }
      .equips{
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        padding-left: $thin_space;
        .equip{
          margin-top: $thin_space;
          font-size: $font-size-mini;
          padding-right: 0;
        }
      }
    }

    .item{
      padding: $space 0 0 0;
      @include checker_background;
      cursor: pointer;
      .param_area{
        display: flex;
        flex-direction: row;
        align-items: flex-end;
        height: 20px;
        .param{
          display: inline-block;
          width: 90%;
          .item_name{
            display: inline-block;
            width: 71%;
          }
          .value{
            display: inline-block;
            width: 29%;
            text-align: right;
            padding-right: $thin_space;
          }
        }
        .go_to_detail{
          @include centering($height:28px);
          width: 10%;
        }
      }
    }

    .item_list_main{
      .misc_area{
        display: flex;
        border-bottom: 1px solid $gray3;
        .label_block{
          height: 52px;
          width: 80px;
          .label{
            display: inline-block;
          }
        }
        .misc{
          height: 52px;
          display: flex;
          width: 300px;
          align-items: center;
          justify-content: center;
          .pager_button{
            text-align: center;
            width: 70px;
            padding: $thin_space;
            color: $gray1;
            font-size: 30px;
            cursor: pointer;
            &:hover{
              filter: brightness(120%);
              transform: scale(1.2);
            }
          }
        }
        .order{
          @include centering($height: 36px);
          width: 100px;
        }
        .select_order{
          position: absolute;
          top: 53px;
          left: 140px;
          .close{
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
          }
          .in_window{
            position: absolute;
            z-index: 1;
            padding: $thin_space;
            @include checker_background;
            width: 230px;
            display: flex;
            flex-wrap: wrap;
            .order{
              margin: $thin_space;
            }
          }
        }
      }
      .item_list{
        width: 100%;
        display: flex;
        flex-direction: column;
        height: calc(100% - 54px);
        padding: $thin_space;
      }
    }
    .disabled{
      opacity: 0.4;
    }

    .detail{
      font-size: $font-size-mini;
      .label{
        font-size: $font-size-normal;
        display: inline-block;
      }
      .item_name{
        margin: $thin_space;
        height: 25px;
        border-bottom: 1px solid $gray3;
      }
      .parameters{
        margin: $thin_space;
        display: flex;
        flex-direction: column;
        justify-content: space-around;
        height: 130px;
        border-bottom: 1px solid $gray3;
        line-height: 100%;
        .parameter{
          width: 100%;
          text-align: right;
          .index{
            display: inline-block;
            width: 30%;
            .sep{
              display: inline-block;
              width: 1rem;
              text-align: center;
            }
          }
          .value{
            display: inline-block;
            width: 70%;
          }
        }
      }
      .flavor_text{
        line-height: 115%;
        margin: $thin_space;
        height: 126px;
      }
      .open_detail_window{
        margin: $thin_space;
        @include centering($height: 30px);
      }
    }

    .main_chara_equips{
      .label_box{
        display: flex;
        flex-direction: row;
        align-content: flex-end;
        justify-content: space-between;
        .topic_medium{
          display: inline-block;
        }
        .label{
          width: 36%;
        }
        .current_parameters_label{
          width: 20%;
        }
        .this_item_label{
          width: 20%;
        }
        .to_status_label{
          width: 20%;
        }
      }
      .main{
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        height: calc(100% - #{$font-size-large});
        .kos{
          position: absolute;
          .ko{
            position: absolute;
            width: 64px;
            opacity: 0.7;
          }
          .upper{
            top: 10px;
            left: 585px;
          }
          .downer{
            top: 75px;
            left: 585px;
          }
        }
        .around_block{
          position: absolute;
          bottom: 0;
          right: $space;
          font-size: $font-size-mini;
        }
        .equips{
          width: 36%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          margin: $subtle_space;
          .equip{
            padding: $space;
            display: flex;
            flex-direction: column;
            justify-content: center;
            cursor: pointer;
            height: $font-size-normal + 1px + $space * 2;
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
          margin: $space 0 $space*3 0;
          width: 20%;
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          .param{
            .text, .number{
              display: inline-block;
            }
          }
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
      left: 80px;
      width: $sub-character-width;
      height: $sub-character-height;
    }
    .total_chara_status{
      position: absolute;
      top: 0;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: 100px;
    }
    .sub_chara_status{
      position: absolute;
      top: 100px;
      left: $character-width;
      width: calc(100% - #{$item_list-main-width} - #{$detail-width} - #{$character-width} - #{$thin_space * 3});
      height: 260px;
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
      height: calc(100% - #{$main-chara-equip-height} - #{$thin_space * 5});
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

<template lang="pug">
  #app
    // いまはコンポーネントに分けていないけど、それぞれをインタラクティブにするタイミングで分割を行う
    .field
      .ground
        img.siroko(
          src="images/ui/siro.png"
          :style="{transform: 'translateX(' + ui.position.siroko + 'px) scale('+ ui.direction.siroko * -1 +', 1)'}"
        )
        img.kuroko(
          src="images/ui/kuro.png"
          :style="{transform: 'translateX(' + ui.position.kuroko + 'px) scale('+ ui.direction.kuroko * -1 +', 1)'}"
        )
    .header.window
      .clock.header_content
        .label
          | 時刻
        .content
          | 1月12日 15:46:33
      .next_event_time.header_content
        .label
          | 次回イベントまで
        .content
          | 25秒
      .dungeon_name.header_content
        .label
          | 現在地
        .content
          | 翠海の輝浜
      .dungeon_depth.header_content
        .label
          | 階層
        .content
          | 26442F
    .right_menu.window
      .item
        | 回復
      .item
        | 装備
      .item
        | ステータス
    .status.window
      .siroko
        .profile
          .name
            | しろこ
          .lv
            | Lv:19
        .gauge
          .hp
            .label
              | HP：
            .value
              | 221 / 350
          .exp
            .label
              | EXP：
            .value
              | 85%
      .kuroko
        .profile
          .name
            | くろこ
          .lv
            | Lv:34445
        .gauge
          .hp
            .label
              | HP：
            .value
              | 9132239 / 13554439
          .exp
            .label
              | EXP：
            .value
              | 13%
    .chat.window
      img.siroko(src="images/ui/chat_siroko.png")
      .chat_window
        .siroko.bubble
          | このへんは特になんにもないね
        .kuroko.bubble
          | 霊力の流れを感じる...
      img.kuroko(src="images/ui/chat_kuroko.png")
    .log.window
      .item
        .at
          | 11:22
        .content
          | ☆神殺しの彗星のアミュレット+65535を拾った！
      .item
        .at
          | 23:55
        .content
          | ★食品サンプルを拾った！
      .item
        .at
          | 7:06
        .content
          | 野うさぎ4体との戦闘だ！
          | HP: (80,54)→(66,13) / 4ターン
</template>

<script lang="ts">
import Constants from "./packs/constants.ts"
export default {
  data: function () {
    return {
      ui: {
        position:{
          siroko: 100,
          kuroko: -40,
        },
        direction:{
          siroko: 1,
          kuroko: -1,
        },
      }
    }
  },
  mounted(){
    this.init();
  },
  methods: {
    init(){
      this.update();
    },
    update(){
      this.proceedCharacter();
      requestAnimationFrame(this.update);
    },
    proceedCharacter(){
      ["siroko", "kuroko"].forEach((name)=>{
        // TODO: speedと反射基準点をcontantsから拾う
        this.ui.position[name] += 1 * this.ui.direction[name];
          if(this.ui.position[name] > Constants.window.ground.right){
              this.ui.direction[name] *= -1;
          }
          if(this.ui.position[name] < Constants.window.ground.left){
              this.ui.direction[name] *= -1;
          }
      });
    },
  }
}
</script>

<style lang="scss" scoped>
  @import "stylesheets/constants";
#app{
  position: relative;
  margin: 50px auto;
  // TODO: ウィンドウサイズはデバッグしやすいように小さめにしているけど、将来的に再検討する
  width: $window-width;
  height: $window-height;
  background-color: $background;
  color: $white;
  font-family: "M PLUS Rounded 1c", sans-serif;
  font-size: 16px;
  .field{
    .ground{
      position: absolute;
      bottom: 100px;
      height: 200px;
      left: 50%;
      img{
        position: absolute;
        height: 200px;
      }
    }
  }
  .window{
    position: absolute;
    border: 1px solid $gray3;
    border-radius: $radius;
    padding: $thin_space;
  }
  .header{
    height: 60px;
    width: 824px;
    top: $space;
    left: $space;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    .header_content{
      .label{
        width: 100%;
        height: 40%;
        font-size: 14px;
        &::after{
          content: "：";
        }
      }
      .content{
        width: 100%;
        height: 60%;
        font-size: 18px;
        padding-right: $space;
        text-align: right;
      }
    }
    .clock{
      width: 25%;
    }
    .next_event_time{
      width: 20%;
    }
    .dungeon_name{
      width: 20%;
    }
    .dungeon_depth{
      width: 15%;
    }
  }
  .right_menu{
    height: $window-height - $space * 2;
    width: 200px - $space * 3;
    top: $space;
    right: $space;
    display: flex;
    flex-direction: column;
    font-size: $font-size-normal;
    .item{
      width: 100%;
      height: 40px;
      background-color: $gray3;
      margin-bottom: $thin_space;
      border-radius: $radius;
      line-height: 100%;
      padding-top: (40px - $font-size-normal) / 2;
      padding-left: $space;
      &:hover{
        filter: brightness(110%);
      }
    }
  }
  .log{
    height: 600px - 140px - $space * 4;
    width: 300px;
    bottom: $space;
    left: $space;
    display: flex;
    flex-direction: column;
    font-size: $font-size-mini;
    .item{
      width: 100%;
      line-height: 120%;
      display: flex;
      margin-bottom: $thin_space;
      .at{
        width: 3rem; // "11:33 " ぶんのスペース
        border-right: 1px solid $gray2;
        padding-right: $thin_space;
      }
      .content{
        display: inline-block;
        width: 100%;
        flex: 1;
        white-space: pre-wrap;
        padding-left: $thin_space;
      }
      &:hover{
        filter: brightness(110%);
      }
    }
  }
  .status{
    height: 80px;
    width: 300px;
    top: 60px + $space * 2;
    left: $space;
    font-size: $font-size-mini;
    display: flex;
    flex-direction: column;
    .siroko .profile{
      background: linear-gradient(to right, rgba(0, 0, 0, 0.4) 60%, rgba(0, 0, 0, 1)  100%), url("/images/ui/profile_background_siroko.png");
    }
    .kuroko .profile{
      background: linear-gradient(to right, rgba(0, 0, 0, 0.4) 60%, rgba(0, 0, 0, 1)  100%), url("/images/ui/profile_background_kuroko.png");
    }
    .siroko, .kuroko {
      width: 100%;
      line-height: 120%;
      display: flex;
      margin-bottom: $thin_space;
      .profile {
        width: 4.5rem; // "Lv:12345 "
        border-right: 1px solid $gray2;
        padding-right: $thin_space;
        background-position: center;
        background-size: cover;
        border-radius: $radius 0 0 $radius;
      }
      .gauge {
        width: 100%;
        flex: 1;
        white-space: pre-wrap;
        padding-left: $thin_space;
        display: flex;
        flex-direction: column;
        .hp, .exp{
          width: 100%;
          .label{
            display: inline-block;
            width: 25%;
            text-align: right;
            padding-right: $thin_space;
          }
          .value{
            display: inline-block;
            width: 75%;
          }
        }
      }
    }
  }
  .chat{
    height: 100px;
    width: $window-width - 500px - $space;
    bottom: $space;
    left: 300px + $space * 2;
    padding: 0;
    display: flex;
    flex-direction: row;
    align-content: space-between;
    img{
      height: 100%;
    }
    .chat_window{
      padding: $thin_space;
      flex: 1;
      display: flex;
      flex-direction: column;
      // TODO: background-colorが発言のあるとこまでになるような工夫をしたい
      .bubble{
        padding: $thin_space;
        background-color: $gray3;
        margin-bottom: $thin_space;
        border-radius: $radius;
      }
      .siroko{
        text-align: left;
      }
      .kuroko{
        text-align: right;
      }
    }
    .kuroko{

    }
  }
}
</style>

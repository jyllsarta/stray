<template lang="pug">
  #app
    // いまはコンポーネントに分けていないけど、それぞれをインタラクティブにするタイミングで分割を行う
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
    .chat.window
    .log.window
      .item
        .at
          | 11:22
        .content
          | ☆神殺しの彗星のアミュレット+65535を拾った！
      .item
        .at
          | 11:22
        .content
          | ★食品サンプルを拾った！
      .item
        .at
          | 11:22
        .content
          | 野うさぎ4体との戦闘だ！
          | HP: (80,54)→(66,13) / 4ターン
</template>

<script lang="ts">
export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
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
    height: $window-height - 100px - $space * 3;
    width: 200px - $space * 3;
    top: $space;
    right: $space;
    display: flex;
    flex-direction: column;
    font-size: $font-size-normal;
    .item{
      width: 100%;
      height: 40px;
      background-color: $main-color;
      margin-bottom: $space;
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
    height: 600px - 160px - $space * 4;
    width: 300px;
    top: $space * 2 + 60px;
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
  .chat{
    height: 100px;
    width: $window-width - $space * 2;
    bottom: $space;
    left: $space;
  }
}
</style>

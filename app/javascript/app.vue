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
    .chat.window
    .log.window
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
  }
  .log{
    height: 600px - 160px - $space * 4;
    width: 250px;
    top: $space * 2 + 60px;
    left: $space;
  }
  .chat{
    height: 100px;
    width: $window-width - $space * 2;
    bottom: $space;
    left: $space;
  }
}
</style>

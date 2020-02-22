<template lang="pug">
  .message_form.window
    .title
      span.description
        | ~おたより欄~ バグ報告、改善要望、なんでもどうぞ！ おたよりはプレイヤーIDとともにすべて公開されます。
      span.link
        a(href="/messages")
          | みんなのおたよりを見る
    .message_box
      textarea.input(v-model="message", cols=100)
      .send.clickable(@click="sendMessage")
        | 送信
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'

export default {
  data: function () {
    return {
      message: "",
    };
  },
  store,
  methods: {
    sendMessage(){
      console.log("sent!")
    },
  },
}
</script>

<style lang="scss" scoped>
  @import "stylesheets/global_setting";
  .message_form{
    margin-top: $space;
    background-color: $background;
    width: 100%;
    .title{
      font-size: $font-size-mini;
      .link{
        :link{
          color: #93baeb;
        }
        :hover{
          color: #d4ddf1;
        }
      }
    }
    .message_box{
      display: flex;
      height: 40px;
      .input{
        color: $white;
        border: 1px solid $gray1;
        border-radius: $radius;
        margin-right: $space;
      }
      .send{
        width: 100px;
        height: 40px;
        font-size: $font-size-normal;
        text-align: center;
        line-height: 100%;
        padding-top: (40px - $font-size-normal)/2;
      }
    }
  }
</style>

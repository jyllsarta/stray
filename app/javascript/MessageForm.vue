<template lang="pug">
  .message_form.window
    .title
      span.description
        | ~おたより欄~ バグ報告、改善要望、なんでもどうぞ！ 
      span.link
        a(href="/messages" target="_blank" rel="noopener noreferrer")
          | みんなのおたよりを見る
      span.description
        | 　画像つきはこちらで！ 
      span.link
        a(href="https://twitter.com/search?q=%23%E3%82%B9%E3%83%94%E3%82%AB%E3%81%A8%E3%83%81%E3%83%AD%E3%83%AB&f=live" target="_blank" rel="noopener noreferrer")
          | #スピカとチロル
            
    .message_box
      textarea.input(v-model="message", cols=100)
      .send.clickable(@click="sendMessage")
        | 送信
    .status
      | {{status}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import ax from "./packs/axios_default_setting.ts";

export default {
  data: function () {
    return {
      message: "",
      status: ""
    };
  },
  store,
  methods: {
    onSuccess(){
      this.message = "";
      this.status= "送信しました！";
    },
    onError(msg){
      this.status = msg || "なんかエラーが出ました";
    },
    sendMessage(){
      const path = `/messages`;
      ax.post(
        path,
        {
          message: this.message,
        })
        .then((results) => {
          console.log(results);
          this.onSuccess();
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
          this.onError(error.response.data.message);
        });
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

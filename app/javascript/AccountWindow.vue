<template lang="pug">
  .menu
    .back(@click="$store.commit('updateWindowShowState', {windowName: 'account', state: false})")
    .window.content
      .title_area
        .back_button(@click="$store.commit('updateWindowShowState', {windowName: 'account', state: false})")
        .title
          | アカウント管理
      .account
        .description
          | ユーザアカウントを登録し、別端末から遊んだり引き継ぎができるようにします。
          | 一度ユーザ名とパスワードを登録したら、進捗はサーバ側に自動保存され続けます。
          | もしアカウントをなくしても復旧措置が可能になるので、登録してスクリーンショットを保存しておくのがおすすめです。
        .windows
          form.backup(onsubmit="return false;")
            .head
              | アカウントを登録
            .item
              .label
                | ユーザID
              .desc_without_border
                | {{$store.state.user.user_id}}
            .item
              .label
                | ユーザ名
              input.desc(type="text", v-model="register.name")
            .item
              .label
                | パスワード
              input.desc(type="password", v-model="register.password")
            .item
              input.desc.submit(type="submit", value="登録", @click="registerName")
            .item(v-if="register.status != 'waiting'")
              .desc_without_border
                | {{register.message}}
          form.restore(onsubmit="return false;")
            .head
              | アカウントを復元(再ログイン)
            .item
              .desc_without_border
                |
            .item
              .label
                | ユーザ名
              input.desc(type="text", v-model="restore.name")
            .item
              .label
                | パスワード
              input.desc(type="password", v-model="restore.password")
            .item
              input.desc.submit(type="submit", value="復元", @click="regenerateToken")
            .item(v-if="restore.status != 'waiting'")
              .desc_without_border
                | {{restore.message}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'

export default {
  data: function () {
    return {
      register: {
        status: "waiting", // "waiting" "sending" "completed" の3値ステート
        message: "",
        name: "",
        password: ""
      },
      restore: {
        status: "waiting", // "waiting" "sending" "completed" の3値ステート
        message: "",
        name: "",
        password: ""
      },
    };
  },
  store,
  mounted(){
  },
  methods: {
    registerName(){
      this.register.status = "sending";
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/register_name`;
      axios.post(
        path,
        {
          authenticity_token: document.querySelector("meta[name=csrf-token]").attributes["content"].textContent
        },
        {
          headers: {
            accept: 'application/json',
            "X-AccessToken": localStorage.access_token,
          },
          data: {
            name: this.register.name,
            password: this.register.password
          }
        })
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.register.message = "成功しました！";
          this.register.status = "completed";
        })
        .catch((error) => {
          console.log(error.response);
          console.warn("NG");
          this.register.message = error.response.data.message;
          this.register.status = "completed";
        });
    },
    regenerateToken(){
      this.restore.status = "sending";
      const path = `/users/regenerate_token`;
      axios.post(
        path,
        {
          authenticity_token: document.querySelector("meta[name=csrf-token]").attributes["content"].textContent
        },
        {
          headers: {
            accept: 'application/json',
          },
          data: {
            name: this.restore.name,
            password: this.restore.password
          }
        })
        .then((results) => {
          console.log(results);
          console.log("OK");
          localStorage.user_id = results.data.user_id;
          localStorage.access_token = results.data.access_token;
          this.restore.message = "成功しました！";
          this.restore.status = "completed";
        })
        .catch((error) => {
          console.log(error.response);
          console.warn("NG");
          this.restore.message = error.response.data.message;
          this.restore.status = "completed";
        });
    },
  }
}
</script>

<style lang="scss" scoped>
@import "stylesheets/global_setting";
.account{
  .description{
    padding: $space;
    white-space: pre-wrap;
    border-bottom: 1px solid $gray3;
  }
  .windows{
    display: flex;
    flex-direction: row;
    padding: $space;
    height: 80%;
    .backup{
      border-right: 1px solid $gray3;
    }
    .backup, .restore{
      width: 50%;
      .head{
        text-align: center;
        color: $accent-color;
      }
      .item{
        text-align: center;
        padding: $space;
        .label{
          display: inline-block;
          margin-right: $space;
          width: 30%;
          text-align: left;
          &::after{
            content: "：";
          }
        }
        .desc{
          display: inline-block;
          border: 1px solid $gray2;
          color: $white;
          width: 50%;
          border-radius: $radius;
        }
        .desc_without_border{
          display: inline-block;
          width: 50%;
          text-align: left;
          height: $font-size-normal * 1.5;
        }
        .submit{
          background-color: $clickable-color;
          height: 30px;
          &:hover{
            filter: brightness(110%);
            transform: scale(1.02);
          }
        }
      }
    }
  }
}
</style>

<template lang="pug">
  .menu
    .back(@click="$store.commit('window/updateWindowShowState', {windowName: 'account', state: false})")
    .window.content
      .title_area
        .back_button.clickable(@click="$store.commit('window/updateWindowShowState', {windowName: 'account', state: false})")
          .arrow
        .title
          | アカウント管理
      .account
        .description
          | ユーザアカウントを登録し、別端末から遊んだり引き継ぎができるようにします。
          | 一度ユーザ名とパスワードを登録したら、進捗はサーバ側に自動保存され続けます。
          | もしアカウントをなくしても復旧措置が可能になるので、登録してスクリーンショットを保存しておくのがおすすめです。
        .windows
          form.backup(onsubmit="return false;")
            .head.topic_medium
              | アカウントを登録
            .item
              .label
                | ユーザID
              .desc_without_border(ref="user_id")
                | {{$store.state.user.user_id}}
              .copy_button(@click="copyUserId").button.clickable
                | {{copy_done ? "完了！" : "コピー"}}
            .item
              .label
                | ユーザ名
              input.desc(type="text", v-model="register.name")
            .item
              .label
                | パスワード
              input.desc(type="password", v-model="register.password")
            .item
              input.desc.submit.clickable(type="submit", value="登録", @click="registerName")
            transition(name="show-in")
              .item(v-if="register.status != 'waiting'")
                .desc_without_border
                  | {{register.message}}
          form.restore(onsubmit="return false;")
            .head.topic_medium
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
              input.desc.submit.clickable(type="submit", value="復元", @click="regenerateToken")
            transition(name="show-in")
              .item(v-if="restore.status != 'waiting'")
                .desc_without_border
                  | {{restore.message}}
</template>

<script lang="ts">
import Constants from "./packs/constants.ts";
import store from './packs/store.ts'
import axios from 'axios'
import ax from "./packs/axios_default_setting.ts";

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
      copy_done: false,
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
      ax.post(
        path,
        {
            name: this.register.name,
            password: this.register.password
        })
        .then((results) => {
          console.log(results);
          this.register.message = "成功しました！";
          this.register.status = "completed";
          this.$store.dispatch("achievement/fetchAchievements");
          this.$store.dispatch("achievement/fetchAchievementCache");
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
      ax.post(
        path,
        {
          name: this.restore.name,
          password: this.restore.password
        })
        .then((results) => {
          console.log(results);
          localStorage.user_id = results.data.user_id;
          localStorage.access_token = results.data.access_token;
          this.restore.message = "成功しました！\n5秒後にページを再読込します。";
          this.restore.status = "completed";
          setTimeout(()=>{ window.location.reload() }, 5000)
        })
        .catch((error) => {
          console.log(error.response);
          console.warn("NG");
          this.restore.message = error.response.data.message;
          this.restore.status = "completed";
        });
    },
    copyUserId(){
      navigator.clipboard.writeText(localStorage.user_id);
      this.copy_done = true;
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
    height: 70%;
    .backup{
      border-right: 1px solid $gray3;
    }
    .backup, .restore{
      width: 50%;
      margin-top: 4%;
      padding: 4%;
      .head{
        display: inline-block;
      }
      .item{
        text-align: center;
        padding: $space;
        .label{
          display: inline-block;
          margin-right: $space;
          width: 40%;
          text-align: left;
          &::after{
            content: "：";
          }
        }
        .desc{
          display: inline-block;
          border: 1px solid $gray1;
          color: $white;
          width: 50%;
          border-radius: $radius;
        }
        .desc_without_border{
          display: inline-block;
          width: 80%;
          text-align: center;
          white-space: pre;
          height: $font-size-normal * 1.5;
        }
        .copy_button{
          display: inline-block;
          width: 20%;
          text-align: center;
          height: $font-size-normal * 1.5;
          border-radius: $radius;
        }
        .submit{
          height: 40px;
          &:hover{
            filter: brightness(110%);
            transform: scale(1.02);
          }
        }
      }
    }
  }

  .show-in-enter-active {
    transition: all .3s;
  }
  .show-in-leave-active {
    transition: all .3s;
  }
  .show-in-enter{
    transform: translateX(-10px);
    opacity: 0;
  }
  .show-in-leave-to{
    transform: translateX(10px);
    opacity: 0;
  }
}
</style>

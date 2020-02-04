<template lang="pug">
  //全然知らなかったけどテンプレート空でも良かったんですね
</template>

<script lang="ts">
import axios from "axios";

export default {
  data: function () {
    return {};
  },
  mounted(){
    // 画面読み込み時など最初に順番を制御して読み込みたいAPI群を制御するコンポーネント
    this.init();
  },
  methods: {
    isAuthorized(){
      return localStorage.access_token !== ""; 
    },
    init(){
      console.log("mounted api system!");
      this.fetchMasterData();
      this.loadUserData();
      if(this.isAuthorized()){
        this.fetchLatestEvents();
      }
    },
    loadUserData(){
      if(localStorage.access_token){
        this.fetchUserModel();
      }
      else{
        this.signUp();
      }
    },
    fetchMasterData(){
      const path = `/masterdata.json`;
      axios.get(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.$store.commit("updateMasterData", results.data);
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    fetchUserModel(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/status.json`;
      axios.get(
        path,
        {
          // TODO: 認証が必要なAPI全部に載せるのはしんどいのでグローバルな設定に移譲したい
          headers: {
            "X-AccessToken": localStorage.access_token,
          }
        })
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.$store.commit("updateUserModel", results.data.payload);
          this.$store.commit("initializeEquipWindow");
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    fetchLatestEvents(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/events.json`;
      axios.post(
        path,
        {
          authenticity_token: document.querySelector("meta[name=csrf-token]").attributes["content"].textContent
        },
        {
          headers: {
            "X-AccessToken": localStorage.access_token,
            accept: 'application/json'
          }
        })
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.$store.commit("updateLatestEvents", results.data);
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    signUp(){
      const path = `/users`;
      axios.post(
        path,
        {
          authenticity_token: document.querySelector("meta[name=csrf-token]").attributes["content"].textContent
        },
        {
          headers: {
            accept: 'application/json'
          }
        })
        .then((results) => {
          console.log(results);
          console.log("OK");
          // TODO: LocalStorageもある主グローバル変数なので、変更させる場所を一元管理したほうがいいかもなあ
          localStorage.user_id = results.data.user_id;
          localStorage.access_token = results.data.access_token;
          this.fetchUserModel();
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
  },
  watch: {
    // storeのイベントタイマーを監視して、0秒になったタイミングで追加のイベントを取得しに行く
    "$store.state.timer.next_event": {
      handler: function(newVal, oldVal){
        if(oldVal > 0 && newVal == 0){
          this.fetchLatestEvents();
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
</style>

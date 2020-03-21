<template lang="pug">
  //全然知らなかったけどテンプレート空でも良かったんですね
</template>

<script lang="ts">
import axios from "axios";
import ax from "./packs/axios_default_setting.ts";

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
          this.$store.commit("masterdata/updateMasterData", results.data);
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
        });
    },
    fetchUserModel(){
      this.$store.dispatch("user/fetchUserModel").then(()=>{
        this.$store.commit("equip_window/initializeEquipWindow", this.$store.state.user.equips);
      });
    },
    fetchLatestEvents(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/events.json`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.$store.commit("event/updateLatestEvents", results.data);
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
          console.log("10秒後に再取得を試みます");
          const ten_seconds_after = new Date().getTime() / 1000 + 10;
          this.$store.commit("event/setNextEventAtTo", ten_seconds_after);
        });
    },
    signUp(){
      const path = `/users`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
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

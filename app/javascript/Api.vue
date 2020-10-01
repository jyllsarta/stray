<template lang="pug">
  //全然知らなかったけどテンプレート空でも良かったんですね
</template>

<script lang="ts">
import axios from "axios";
import ax from "./packs/axios_default_setting.ts";
import Constants from "./packs/constants.ts";

export default {
  data: function () {
    return {
      session_started_at: 0,
      session_id: 0,
    };
  },
  mounted(){
    // 画面読み込み時など最初に順番を制御して読み込みたいAPI群を制御するコンポーネント
    this.init();
    this.fillDebugUserId();
  },
  methods: {
    fillDebugUserId(){
      if (process.env.NODE_ENV === 'production') {
        return;
      }
      console.log("開発環境なのでデバッグコマンドにuser_idを埋め込みます");
      document.querySelectorAll("input[type=hidden][name=user_id]").forEach((item) => {
        item.attributes["value"].value = localStorage.user_id;
      })
    },
    isAuthorized(){
      return localStorage.access_token !== "";
    },
    retryFetchLatestEvents(){
      console.log("10秒後に再取得を試みます");
      const ten_seconds_after = new Date().getTime() / 1000 + 10;
      this.$store.commit("event/setNextEventAtTo", ten_seconds_after);
    },
    init(){
      console.log("mounted api system!");
      this.initializeSession();
      this.fetchMasterData();
      this.loadUserData();
      if(this.isAuthorized()){
        this.fetchLatestEvents();
      }
    },
    initializeSession(){
      this.session_id = Math.floor(Math.random() * 1000000000);
      this.session_started_at = Math.floor(new Date().getTime() / 1000);
    },
    loadUserData(){
      if(localStorage.access_token){
        console.log("fetch user model");
        this.fetchUserModel();
      }
      else{
        console.log("sign up");
        this.signUp();
      }
    },
    fetchMasterData(){
      const path = `/masterdata.json`;
      axios.get(path)
        .then((results) => {
          console.log(results);
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
      //return;
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/events.json`;
      if(!user_id){
        this.retryFetchLatestEvents();
        return;
      }
      ax.post(path,{}, {headers: {
          "X-SessionId": this.session_id,
          "X-SessionStartedAt": this.session_started_at,
        }})
        .then((results) => {
          if(this.$store.getters["event/isVersionChanged"](results.data.version)){
            this.$store.commit("event/addEventLog", {message: `新Ver${results.data.version}が公開されています！\nCtrl+Shift+Rで更新してね`});
          }
          else if(!this.$store.state.event.version){
            this.$store.commit("event/setVersion", results.data.version);
          }
          this.$store.commit("event/queueEvents", results.data);
          this.$store.commit("user/updateUserVelocity", results.data.after_velocity);
        })
        .catch((error) => {
          console.warn(error.response);
          console.warn("NG");
          if(error.response?.status == 400){
            this.$store.commit("window/updateWindowShowState", {windowName: "session_expired_frame", state: true});
          }
          else{
            this.retryFetchLatestEvents();
          }
        });
    },
    signUp(){
      const path = `/users`;
      ax.post(path)
        .then((results) => {
          console.log(results);
          localStorage.user_id = results.data.user_id;
          localStorage.access_token = results.data.access_token;
          ax.defaults.
            headers = {
            "X-AccessToken": localStorage.access_token,
            accept: "application/json",
          } // axios_default_setting を読み込み直す処理を入れるのが理想
          this.fetchUserModel();
          this.$store.commit("event/addEventLog", {message: Constants.welcomeMessage});
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

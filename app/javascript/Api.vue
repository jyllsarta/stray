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
    this.init();
  },
  methods: {
    init(){
      console.log("mounted api system!");
      this.fetchMasterData();
      this.loadUserData();
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
        .catch((results) => {
          console.warn(results);
          console.warn("NG");
        });
    },
    fetchUserModel(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/status.json`;
      axios.get(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.$store.commit("updateUserModel", results.data.payload)
        })
        .catch((results) => {
          console.warn(results);
          console.warn("NG");
        });
    },
    fetchLatestEvents(){
      const user_id = localStorage.user_id;
      const path = `/users/${user_id}/events.json`;
      axios.get(path)
        .then((results) => {
          console.log(results);
          console.log("OK");
          this.$store.commit("updateLatestEvents", results.data.events)
        })
        .catch((results) => {
          console.warn(results);
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
            accept: 'application/json',
            data: {},
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
        .catch((results) => {
          console.warn(results);
          console.warn("NG");
        });
    },
  }
}
</script>

<style lang="scss" scoped>
</style>

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
      this.fetchUserModel();
      this.fetchLatestEvents();
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
      const user_id = 333;
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
      const user_id = 333;
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
  }
}
</script>

<style lang="scss" scoped>
</style>

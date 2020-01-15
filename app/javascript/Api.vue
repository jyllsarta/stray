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
        })
    },
  }
}
</script>

<style lang="scss" scoped>
</style>

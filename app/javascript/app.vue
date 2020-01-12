<template lang="pug">
  #app
    p
      | {{ message }}
      a(href="/")
        | ぽよ
</template>

<script lang="ts">
export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style lang="scss" scoped>
#app{
  margin: 50px auto;
  // TODO: ウィンドウサイズはデバッグしやすいように小さめにしているけど、将来的に再検討する
  width: 800px;
  height: 600px;
  background-color: #DADADA;
}
</style>

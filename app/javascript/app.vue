<template lang="pug">
  #app
    p
      | {{ message }}
      a(href="/")
        | ぽよ
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style lang="scss" scoped>
p {
  font-size: 2em;
  text-align: center;
  a {
    text-decoration: none;
  }
}
</style>

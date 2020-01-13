import Vue from 'vue'
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App),
  }).$mount();
  document.getElementById("window").appendChild(app.$el);
  window.stray = app; // TODO: productionビルド時に代入させないようにしたい
});

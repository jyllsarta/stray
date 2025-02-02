import "@babel/polyfill";
import Vue from 'vue'
import App from '../app.vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App),
  }).$mount();
  document.getElementById("window").appendChild(app.$el);
  if (process.env.NODE_ENV !== 'production') {
    window.stray = app;
  }
});

import "@babel/polyfill";
import Vue from 'vue'
import App from '../app.vue'
import * as Sentry from "@sentry/browser";
import { Vue as VueIntegration } from "@sentry/integrations";

if (process.env.NODE_ENV === 'production') {
  Sentry.init({
    dsn: "https://6c19d26f2b2d49a69e5a03826d7ff625@o438865.ingest.sentry.io/5404630",
    integrations: [new VueIntegration({ Vue, attachProps: true, logErrors: true })],
  });
}

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(App),
  }).$mount();
  document.getElementById("window").appendChild(app.$el);
  if (process.env.NODE_ENV !== 'production') {
    window.stray = app;
  }
});

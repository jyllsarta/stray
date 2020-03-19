import { store } from '../store.ts'
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
    next_event_at: 123123123,
    events: []
  },
  getters: {
  },
  mutations: {
    setNextEventAtTo(state, payload) {
      state.next_event_at = payload;
    },
    updateLatestEvents(state, payload) {
      state.next_event_at = payload.next_event_at;
      state.events = state.events.concat(payload.events).slice(-Constants.log.maxLength);
    },
    addEventLog(state, payload){
      const manualEvent = {
        resolved: true,
        detail: {},
        logs: [
          {
            // 手動追加されるログは同時刻に発生することがあり得るので、ユニーク性を担保するためにサロゲートキーを発行する
            pseudo_id: Math.floor(Math.random() * 1000000000),
            at: Math.floor(new Date()/1000),
            message: payload.message,
          }
        ],
        type: payload.type,
      };
      state.events.push(manualEvent);
      state.events = state.events.slice(-Constants.log.maxLength)
    },
  }
}
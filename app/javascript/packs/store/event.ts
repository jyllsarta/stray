import { store } from '../store.ts'

export default {
  namespaced: true,
  state: {
    next_event_at: 123123123,
    events: []
  },
  getters: {
  },
  mutations: {
    updateLatestEvents(state, payload) {
      state.next_event_at = payload.next_event_at;
      state.events = state.events.concat(payload.events);
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
    },
  }
}
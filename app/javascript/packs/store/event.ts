import { store } from '../store.ts'
import Constants from "../constants.ts";

export default {
  namespaced: true,
  state: {
    next_event_at: 123123123,
    events: [],
    eventsQueue: [],
    version: null,
  },
  getters: {
    isVersionChanged: (state) => (version) =>  {
      // 未設定ならバージョン違いとは判定しない
      if(!state.version){
        return false;
      }
      return state.version != version;
    }
  },
  mutations: {
    setVersion(state, payload) {
      state.version = payload;
    },
    setNextEventAtTo(state, payload) {
      state.next_event_at = payload;
    },
    updateLatestEvents(state, payload) {
      state.next_event_at = payload.next_event_at;
      for(let event of payload.events){
        // 回復ログは最新の一件のみを保存する
        if(event.type === 'resurrect' && state.events.slice(-1)?.pop()?.type === 'resurrect'){
          state.events.pop();
        }
        state.events = state.events.concat([event]).slice(-Constants.log.maxLength);
      }
    },
    queueEvents(state, payload) {
      state.next_event_at = payload.next_event_at;
      state.eventsQueue = state.eventsQueue.concat(payload.events);
    },
    dequeueEvent(state){
      state.events = state.events.concat([state.eventsQueue.shift()]).slice(-Constants.log.maxLength);
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
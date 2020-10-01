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
    },
    // ただ1~2個イベント拾っただけの時は出さない(ふたつとるのは端末時間的にあり得るので余裕を持って閾値は3)
    isDequeueMode: (state) =>  {
      return state.eventsQueue.length >= 3;
    },
    // 最後に消化したイベントでの時刻
    pseudoCurrentTime: (state) =>  {
      const lastEvent = state.events.slice(-1)[0];
      if(!lastEvent){
        return new Date();
      }
      return new Date(lastEvent.logs[0].at * 1000);
    },
  },
  mutations: {
    setVersion(state, payload) {
      state.version = payload;
    },
    setNextEventAtTo(state, payload) {
      state.next_event_at = payload;
    },
    queueEvents(state, payload) {
      state.next_event_at = payload.next_event_at;
      state.eventsQueue = state.eventsQueue.concat(payload.events);
    },
    dequeueEvent(state){
      const event = state.eventsQueue.shift();
      // 回復ログは最新の一件のみを保存する
      if(event.type === 'resurrect' && state.events.slice(-1)?.pop()?.type === 'resurrect'){
        state.events.pop();
      }
      state.events = state.events.concat([event]).slice(-Constants.log.maxLength);
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
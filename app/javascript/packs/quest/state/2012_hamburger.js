class OriginalState {
  constructor() {
    this.id = 2012;
    this.ttl = 3;
    this.title = "軽業";
    this.icon = "20404.gif";
    this.description = "3ターン目まで力・技ダメージ+1。4ターン目以降は力・技ダメージ-1。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){
    state.owner.power += 1;
    state.owner.tech += 1;
  }

  onTurnEnd(state){
    if(state.ttl === 1){
      const stateId = 2013; // ハンバーガーデバフに切り替える
      const isPlayer = state.owner.name === "プレイヤー"; // イ〜〜〜！やりたくない
      state.battle.addState(isPlayer, stateId);
      state.flash();
    }
  }
}

module.exports = new OriginalState();

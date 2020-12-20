class Burning {
  constructor() {
    this.id = 101;
    this.ttl = -1;
    this.title = "炎風";
    this.icon = "burning.gif";
    this.description = "ダメージを2回以上受けたターンの終了時、追加で2ダメージを受ける。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: true,
      onTurnStart: false,
      onTurnEnd: false,
      onDamage: false,
    }
  }

  getInitialCondition(){
    return {
    };
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){
    const burningStateId = 1001;
    state.battle.addState(true, burningStateId);
    state.battle.addState(false, burningStateId);
  }
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){}
}

module.exports = new Burning();

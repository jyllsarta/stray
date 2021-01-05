class FieldEffectBurning {
  constructor() {
    this.id = 103;
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
    const stateId = 1003;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){}
}

module.exports = new FieldEffectBurning();

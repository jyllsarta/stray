class Poison {
  constructor() {
    this.id = 1;
    this.ttl = 3;
    this.icon = "poison.gif";
    this.description = "毒状態。毎ターン終了時に1ダメージを受ける。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){
    state.owner.hp -= 1;
  }
};

module.exports = new Poison();
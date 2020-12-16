class Regenerate {
  constructor() {
    this.id = 2;
    this.ttl = 5;
    this.icon = "regenerate.gif";
    this.guideMessage = "リジェネ状態。毎ターン終了時に2回復。";
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
    state.owner.hp += 2;
  }
};

module.exports = new Regenerate();

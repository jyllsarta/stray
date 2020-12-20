class Regenerate {
  constructor() {
    this.id = 2;
    this.ttl = 5;
    this.title = "リジェネ";
    this.icon = "regenerate.gif";
    this.description = "リジェネ状態。毎ターン終了時に2回復。";
    this.callbacks = {
      onAdd: false,
      onTurnStart: false,
      onTurnEnd: true,
      onDamage: false,
    }
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(){}
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){
    state.owner.hp += 2;
    state.flash();
  }
}

module.exports = new Regenerate();

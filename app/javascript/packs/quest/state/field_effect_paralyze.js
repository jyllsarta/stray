class FieldEffectParalyze {
  constructor() {
    this.id = 104;
    this.ttl = -1;
    this.title = "轟雷";
    this.icon = "paralyze.gif";
    this.description = "ステート「雷」を付与する。\n雷：スキルの被ダメージ+1/発動後轟になる\n轟：通常攻撃の被ダメージ+1/発動後雷になる";
  }

  getInitialCondition(){
    return {
    };
  }

  showParameter(state){
    return "-";
  }

  onAdd(state){
    const stateId = 1004;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
}

module.exports = new FieldEffectParalyze();

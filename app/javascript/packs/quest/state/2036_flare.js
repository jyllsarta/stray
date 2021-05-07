class OriginalState {
  constructor() {
    this.id = 2036;
    this.ttl = 3;
    this.title = "フレア";
    this.icon = "40211.gif";
    this.description = "被ダメージ分だけ最大HPが減少する。さらにターン終了時に1ダメージ【火】。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onDamage(state, damageAmount){
    state.owner.hp_max -= damageAmount;
    state.flash();
  }

  onTurnEnd(state){
    state.battle.skillResolver.resolveFireDamage(state.owner, state.opponent, true, 1);
  }
}

module.exports = new OriginalState();

class OriginalState {
  constructor() {
    this.id = 2038;
    this.ttl = -1;
    this.title = "フルカーズ";
    this.icon = "1008051.gif";
    this.description = "ダメージを受けたとき、同じだけのダメージを相手にも与える。(このダメージでHPが0にはならない)";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onDamage(state, damageAmount){
    if(state.opponent.hp >= 1){
      state.opponent.hp -= damageAmount;
      if(state.opponent.hp <= 0){
        state.opponent.hp = 1;
      }
    }
    state.flash();
  }
}

module.exports = new OriginalState();

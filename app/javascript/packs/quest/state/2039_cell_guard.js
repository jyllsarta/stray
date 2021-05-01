class OriginalState {
  constructor() {
    this.id = 2039;
    this.ttl = -1;
    this.title = "セルガード";
    this.icon = "1008061.gif";
    this.description = "このターンに受けたダメージと同じ値のシールドを次のターン開始時に展開する。";
  }

  getInitialCondition(){
    return {
      damage: 0
    };
  }

  showParameter(state){
    return state.condition.damage;
  }

  onDamage(state, damageAmount){
    state.condition.damage += damageAmount;
  }

  onTurnStart(state){
    if(state.condition.damage > 0){
      state.owner.addShield(state.condition.damage);
      state.flash();
    }
    state.condition.damage = 0;
  }
}

module.exports = new OriginalState();

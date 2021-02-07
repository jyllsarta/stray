class EntityParalyze {
  constructor() {
    this.id = 2030;
    this.ttl = -1;
    this.title = "闇夜の衣";
    this.icon = "1006051.gif";
    this.description = "ターン終了時に累計ダメージが9点以下だった場合、ターン開始時のHPまで巻き戻す。";
  }

  getInitialCondition(){
    return {
      turnDamage: 0,
    };
  }

  showParameter(state){
    return state.condition.turnDamage;
  }

  onDamage(state, damageAmount){
    state.condition.turnDamage += damageAmount;
  }

  onTurnEnd(state){
    if(state.owner.hp > 0 && state.condition.turnDamage <= 9){
      state.owner.addHp(state.condition.turnDamage);
      state.flash();
    }
    state.condition.turnDamage = 0;
  }
}

module.exports = new EntityParalyze();

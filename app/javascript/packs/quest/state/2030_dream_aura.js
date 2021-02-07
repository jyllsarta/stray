class EntityParalyze {
  constructor() {
    this.id = 2030;
    this.ttl = -1;
    this.title = "闇夜の衣";
    this.icon = "1006051.gif";
    this.description = "ターン終了時にダメージ差分が9点以下だった場合、ターン開始時のHPまで巻き戻す。";
  }

  getInitialCondition(){
    return {
      turnStartHp: 0,
    };
  }

  showParameter(state){
    return Math.max(state.condition.turnStartHp - state.owner.hp, 0);
  }

  onTurnStart(state, damageAmount){
    state.condition.turnStartHp = state.owner.hp;
  }

  onTurnEnd(state){
    // 生きていて、HP差分が9点以下で、回復したほうが得なときは回復する
    if(state.owner.hp > 0 && state.condition.turnStartHp - state.owner.hp <= 9 && state.condition.turnStartHp > state.owner.hp){
      state.owner.hp = state.condition.turnStartHp;
      state.flash();
    }
    state.condition.turnStartHp = state.owner.hp;
  }
}

module.exports = new EntityParalyze();

class EntityParalyze2 {
  constructor() {
    this.id = 1008;
    this.ttl = -1;
    this.title = "轟";
    this.icon = "paralyze2.gif";
    this.description = "通常攻撃の被ダメージ+1。この効果の発動後はスキルダメージ+1の雷ステートに変化する。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "物";
  }

  onDamage(state, damageAmount, isPhysical){
    if(isPhysical){
      state.owner.hp -= 1;
      const stateId = 1004; // ハンバーガーから拾ってきてしまった悔しいコード
      const isPlayer = state.owner.name === "プレイヤー";
      state.battle.addState(isPlayer, stateId);
      state.flash();  
      this.removeThisState(state);
    }
  }

  removeThisState(state){
    state.owner.states = state.owner.states.filter(s=>s.id!==state.id);
  }
}

module.exports = new EntityParalyze2();

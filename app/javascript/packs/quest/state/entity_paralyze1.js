class EntityParalyze1 {
  constructor() {
    this.id = 1004;
    this.ttl = -1;
    this.title = "雷";
    this.icon = "paralyze1.gif";
    this.description = "スキルの被ダメージ+1。この効果の発動後は通常攻撃ダメージ+1の轟ステートに変化する。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "魔";
  }

  onDamage(state, damageAmount, isPhysical){
    if(!isPhysical){
      state.owner.hp -= 1;
      const stateId = 1008; // ハンバーガーから拾ってきてしまった悔しいコード
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

module.exports = new EntityParalyze1();

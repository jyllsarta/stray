class EntityWoodRegenerate {
  constructor() {
    this.id = 1002;
    this.ttl = -1;
    this.title = "翠癒";
    this.icon = "wood_regenerate.gif";
    this.description = "ダメージを受けなかったターンの終了時、HPを1回復する。";
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return state.condition.damageCount;
  }

  onDamage(state, damageAmount){
    state.condition.damageCount += 1;
  }
  onTurnEnd(state){
    if(state.condition.damageCount == 0){
      state.owner.addHp(1);
      state.flash();
    }
    state.condition.damageCount = 0;
  }
}

module.exports = new EntityWoodRegenerate();

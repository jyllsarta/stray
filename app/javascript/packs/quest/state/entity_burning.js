class EntityBurning {
  constructor() {
    this.id = 1003;
    this.ttl = -1;
    this.title = "炎風";
    this.icon = "burning.gif";
    this.description = "ダメージを2回以上受けたターンの終了時、追加で【火】の2ダメージを受ける。";
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
    if(state.condition.damageCount >= 2){
      // お行儀わるし まあ... なにか問題が起きたら直そう
      // 自身にダメージが溜まってたら爆発してダメージを受ける
      state.battle.skillResolver.resolveFireDamage(state.owner, state.opponent, true, 2);
      state.flash();
    }
    state.condition.damageCount = 0;
  }
}

module.exports = new EntityBurning();

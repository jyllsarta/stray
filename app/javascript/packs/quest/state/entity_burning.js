class EntityBurning {
  constructor() {
    this.id = 1003;
    this.ttl = -1;
    this.title = "炎風";
    this.icon = "burning.gif";
    this.description = "ダメージを2回以上受けたターンの終了時、追加で2ダメージを受ける。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: false,
      onTurnStart: false,
      onTurnEnd: true,
      onDamage: true,
    }
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return state.condition.damageCount;
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){
    state.condition.damageCount += 1;
  }
  onTurnEnd(state){
    if(state.condition.damageCount >= 2){
      state.owner.damage(2);
      state.flash();
    }
    state.condition.damageCount = 0;
  }
}

module.exports = new EntityBurning();

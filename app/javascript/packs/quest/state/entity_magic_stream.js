class EntitymagicStream {
  constructor() {
    this.id = 1007;
    this.ttl = -1;
    this.title = "魔濁";
    this.icon = "default.gif";
    this.description = "ターン終了時にMP+20。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: false,
      onTurnStart: false,
      onTurnEnd: true,
      onDamage: false,
    }
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return ""; //バグったらごめんって感じ
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){
    state.owner.addMp(20);
  }
}

module.exports = new EntitymagicStream();

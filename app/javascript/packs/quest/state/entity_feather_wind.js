class EntityFeatherWind {
  constructor() {
    this.id = 1005;
    this.ttl = -1;
    this.title = "翼風";
    this.icon = "default.gif";
    this.description = "ダメージを与えるたびにMPを5回復。";
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
  onDamage(state, damageAmount){
    state.opponent.addMp(5);
  }
  onTurnEnd(state){}
}

module.exports = new EntityFeatherWind();

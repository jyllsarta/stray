class EntityFeatherWind {
  constructor() {
    this.id = 1005;
    this.ttl = -1;
    this.title = "翼風";
    this.icon = "default.gif";
    this.description = "ダメージを与えるたびにMPを5回復。";
  }

  getInitialCondition(){
    return {
      damageCount: 0,
    };
  }

  showParameter(state){
    return ""; //バグったらごめんって感じ
  }

  onDamage(state, damageAmount){
    state.opponent.addMp(5);
  }
}

module.exports = new EntityFeatherWind();

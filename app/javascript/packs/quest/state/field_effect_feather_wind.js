class FieldEffectFeatherWind {
  constructor() {
    this.id = 105;
    this.ttl = -1;
    this.title = "翼風";
    this.icon = "feather_wind.gif";
    this.description = "ダメージを与えるたびにMPを5回復。";
  }

  getInitialCondition(){
    return {
    };
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){
    const stateId = 1005;
    state.battle.addState(true, stateId);
    state.battle.addState(false, stateId);
  }
}

module.exports = new FieldEffectFeatherWind();

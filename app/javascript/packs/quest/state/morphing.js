class Morphing {
  constructor() {
    this.id = 102;
    this.ttl = -1;
    this.title = "変幻";
    this.icon = "morphing.gif";
    this.description = "ターン開始時、力と技の低い方に+10の補正。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onTurnStart: false,
      onTurnEnd: false,
      onDamage: false,
    }
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onTurnStart(state){
  }
  onDamage(state, damageAmount){
  }
  onTurnEnd(state){
  }
}

module.exports = new Morphing();

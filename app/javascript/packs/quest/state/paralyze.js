class Paralyze {
  constructor() {
    this.id = 100;
    this.ttl = -1;
    this.title = "雷痺";
    this.icon = "paralyze.gif";
    this.description = "5回ダメージを受けるとスタンし、そのターン中の力技が0になる。ダメージを受けなかったらターン終了時にカウント-1。";
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

module.exports = new Paralyze();

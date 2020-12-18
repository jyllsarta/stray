class Paralyze {
  constructor() {
    this.id = 100;
    this.ttl = -1;
    this.title = "雷痺";
    this.icon = "paralyze.gif";
    this.description = "ダメージを受けるたびに雷痺ポイント+1。5点蓄積でスタンし、そのターン中の力技が0になる。ターン終了時にノーダメージなら雷痺を1点回復。";
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

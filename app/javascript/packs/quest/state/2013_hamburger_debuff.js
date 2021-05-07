class OriginalState {
  constructor() {
    this.id = 2013;
    this.ttl = -1;
    this.title = "力尽きた";
    this.icon = "20404_2.gif";
    this.description = "力尽きた。力・技ダメージ-1。";
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return "∞";
  }

  onAdd(state){
    state.owner.power -= 2; // 事前にハンバーガーバフをもらっているので、その分を打ち消してマイナス1にする
    state.owner.tech -= 2;
  }
}

module.exports = new OriginalState();

class OriginalState {
  constructor() {
    this.id = 2010;
    this.ttl = -1;
    this.title = "ストーム";
    this.icon = "20207.gif";
    this.description = "これの蓄積数だけ、ストームのダメージが増加。";
  }

  getInitialCondition(){
    return {
      value: 1
    };
  }

  showParameter(state){
    return state.condition.value;
  }
}

module.exports = new OriginalState();

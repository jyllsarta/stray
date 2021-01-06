class LoseInfinitySkill {
  constructor() {
    this.id = 2001;
    this.ttl = 1;
    this.title = "カラミティ";
    this.icon = "lose_infinity_skill.gif";
    this.description = "ターン終了時、全スキルが∞を失う。";
    // これダサい！可能ならやめたい
    this.callbacks = {
      onAdd: false,
      onTurnStart: false,
      onTurnEnd: true,
      onDamage: false,
    }
  }

  getInitialCondition(){
    return {};
  }

  showParameter(state){
    return state.ttl;
  }

  onAdd(state){}
  onTurnStart(state){}
  onDamage(state, damageAmount){}
  onTurnEnd(state){
    for(let skill of state.owner.skills){
      skill.reusable = false;
    }
  }
}

module.exports = new LoseInfinitySkill();

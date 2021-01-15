module.exports = class StateInstance {
  constructor(stateId, stateMaster, battle, owner, opponent) {
    this.stateId = stateId;
    this.stateMaster = stateMaster;
    this.battle = battle;
    this.owner = owner;
    this.opponent = opponent;
    this.ttl = this.stateMaster.ttl;
    this.condition = this.stateMaster.getInitialCondition();
    this.showParameter = (()=>{ return this.stateMaster.showParameter(this) });
    this.id = Math.floor(Math.random() * 1000000000);
    this.isFlashing = false;
  }

  flash(){
    this.isFlashing = true;
    //実装を意識して具体的数値を書いちゃってるの悔しい
    setTimeout(()=>{ this.isFlashing =false; }, 300);
  }

  onAdd(){
    if(!this.stateMaster.onAdd){
      return;
    }
    this.stateMaster.onAdd(this);
  }
  onTurnStart(){
    if(!this.stateMaster.onTurnStart){
      return;
    }
    this.stateMaster.onTurnStart(this);
  }
  onTurnEnd(){
    if(!this.stateMaster.onTurnEnd){
      return;
    }
    this.stateMaster.onTurnEnd(this);
  }
  onDamage(){
    if(!this.stateMaster.onDamage){
      return;
    }
    this.stateMaster.onDamage(this);
  }
};

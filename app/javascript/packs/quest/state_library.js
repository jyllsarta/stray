let states = [
  require("./state/poison"),
  require("./state/regenerate"),
  require("./state/burning"),
  require("./state/burning_entity"),
  require("./state/paralyze"),
  require("./state/paralyze_entity"),
  require("./state/morphing"),
]

module.exports = class StateLibrary {
  constructor() {
    this.library = {};
    states.forEach((state)=> {
      if(this.library[state.id]){
        console.error(`id: ${state.id} is already set`);
      }
      this.library[state.id] = state;
    })
  }

  findState(stateId){
    if(!this.library[stateId]){
      console.error(`undefined state id:${stateId}`);
    }
    return this.library[stateId];
  }
};

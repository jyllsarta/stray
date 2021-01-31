let states = [
  require("./state/poison"),
  require("./state/regenerate"),
  require("./state/field_effect_burning"),
  require("./state/entity_burning"),
  require("./state/field_effect_paralyze"),
  require("./state/entity_paralyze"),
  require("./state/field_effect_dark_soul"),
  require("./state/entity_dark_soul"),
  require("./state/field_effect_feather_wind"),
  require("./state/entity_feather_wind"),
  require("./state/field_effect_wood_regenerate"),
  require("./state/entity_wood_regenerate"),
  require("./state/field_effect_magic_stream"),
  require("./state/entity_magic_stream"),
  require("./state/morphing"),
  require("./state/lose_infinity_skill"),
  require("./state/2005_crample"),
  require("./state/2006_twins"),
  require("./state/2007_break"),
  require("./state/2008_sakuramochi"),
  require("./state/2009_fallin"),
  require("./state/2010_storm"),
  require("./state/2011_reverie"),
  require("./state/2012_hamburger"),
  require("./state/2013_hamburger_debuff"),
  require("./state/2014_mana_blur"),
  require("./state/2015_onigiri"),
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

let states = [
  require("./state/poison"),
  require("./state/regenerate"),
  require("./state/field_effect_burning"),
  require("./state/entity_burning"),
  require("./state/field_effect_paralyze"),
  require("./state/entity_paralyze1"),
  require("./state/entity_paralyze2"),
  require("./state/field_effect_dark_soul"),
  require("./state/entity_dark_soul"),
  require("./state/field_effect_feather_wind"),
  require("./state/entity_feather_wind"),
  require("./state/field_effect_wood_regenerate"),
  require("./state/entity_wood_regenerate"),
  require("./state/field_effect_magic_stream"),
  require("./state/entity_magic_stream"),
  require("./state/field_effect_108"),
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
  require("./state/2016_awa"),
  require("./state/2017_rakuyo"),
  require("./state/2018_autoheal"),
  require("./state/2019_break"),
  require("./state/2020_drain"),
  require("./state/2021_autoheal2"),
  require("./state/2022_curse"),
  require("./state/2023_corrupting"),
  require("./state/2024_flyburn"),
  require("./state/2025_boost_paralyze"),
  require("./state/2026_corrupting2"),
  require("./state/2027_autoheal3"),
  require("./state/2028_rakuyo2"),
  require("./state/2029_curse2"),
  require("./state/2030_dream_aura"),
  require("./state/2031_promote"),
  require("./state/2032_protect"),
  require("./state/2033_seeds"),
  require("./state/2034_autoheal3"),
  require("./state/2035_onigiri"),
  require("./state/2036_flare"),
  require("./state/2037_autoheal5"),
  require("./state/2038_full_curse"),
  require("./state/2039_cell_guard"),
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

let BattleFactory = require("./battle_factory");

const battle = new BattleFactory().getBattle();

battle.execute();

console.log(JSON.stringify(battle.outcome()));

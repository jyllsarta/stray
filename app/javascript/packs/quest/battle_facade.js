let Battle = require("./battle");
let Player = require("./player");
let Enemy = require("./enemy");

module.exports = class BattleFacade{
    constructor() {
    }

    newBattle(){
        const battle = new Battle(new Player(), new Enemy(), null);
        battle.execute();
    }
};

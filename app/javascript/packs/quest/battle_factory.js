let Battle = require("./battle");
let Player = require("./player");
let Enemy = require("./enemy");

module.exports = class BattleFactory{
    constructor() {
        this.battle = new Battle(new Player(), new Enemy(), null);
    }

    getBattle(){
        return this.battle;
    }
};

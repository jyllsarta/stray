let Character = require("./character");

module.exports = class Player extends Character {
    constructor(name, hp, power, tech, special, deck, skills) {
        super(name, hp, power, tech, special, deck, skills);
    }
};

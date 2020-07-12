let Character = require("./character");

module.exports = class Player extends Character {
    constructor(name, hp, deck, skills) {
        super(name, hp, deck, skills);
    }
};

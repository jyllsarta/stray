let Character = require("./character");

module.exports = class Player extends Character {
    constructor(name, hp, deck) {
        super(name, hp, deck);
    }
};

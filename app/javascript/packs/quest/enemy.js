let Character = require("./character");

module.exports = class Enemy extends Character {
    constructor(name, hp, deck) {
        super(name, hp, deck);
    }
};

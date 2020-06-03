let Character = require("./character");

module.exports = class Enemy extends Character {
    constructor(hp, deck) {
        super(hp, deck);
    }
};

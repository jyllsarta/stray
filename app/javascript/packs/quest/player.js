let Character = require("./character");

module.exports = class Player extends Character {
    constructor(hp, deck) {
        super(hp, deck);
    }
};

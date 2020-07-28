let Character = require("./character");

module.exports = class Player extends Character {
    constructor(name, imageName, hp, power, tech, special, deck, skills) {
        super(name, imageName, hp, power, tech, special, deck, skills);
    }
};

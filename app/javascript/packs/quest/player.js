let Character = require("./character");

module.exports = class Player extends Character {
    constructor(name, imageName, scaleType, hp, power, tech, special, deck, skills) {
        super(name, imageName, scaleType, hp, power, tech, special, deck, skills);
    }
};

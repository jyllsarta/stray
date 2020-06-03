module.exports = class Character{
    constructor(hp, deck) {
        this.hp = hp;
        this.deck = deck;
    }

    isAlive(){
        return this.hp > 0;
    }
};

let Battle = require("./battle");
let Player = require("./player");
let Enemy = require("./enemy");
let Deck = require("./deck");
let Card = require("./card");

module.exports = class BattleFactory{
    constructor(input) {
        this.player = new Player(input.playerHp, this.makeDeck(input.playerCards));
        this.enemy = new Enemy(input.enemyHp, this.makeDeck(input.enemyCards));
        this.seed = input.seed;
    }

    getBattle(){
        return new Battle(this.player, this.enemy, this.seed);
    }

    // private

    makeDeck(cardsArray){
        let cards = [];
        for(let card of cardsArray){
            cards.push(new Card("test", card.str, card.dex, card.def, card.agi));
        }
        return new Deck(cards);
    }
};

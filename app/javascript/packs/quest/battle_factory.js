let Battle = require("./battle");
let Player = require("./player");
let Enemy = require("./enemy");
let Deck = require("./deck");
let Card = require("./card");

module.exports = class BattleFactory{
    constructor(input) {
        this.player = new Player("プレイヤー", input.playerHp, this.makeDeck(input.playerCards));
        this.enemy = new Enemy(input.enemyName, input.enemyHp, this.makeDeck(input.enemyCards));
        this.seed = input.seed;
    }

    getBattle(){
        return new Battle(this.player, this.enemy, this.seed);
    }

    // private

    makeDeck(cardsArray){
        let cards = [];
        for(let card of cardsArray){
            cards.push(new Card(card.id, card.name, card.power, card.tech));
        }
        return new Deck(cards);
    }
};

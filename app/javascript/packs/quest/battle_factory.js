let Battle = require("./battle");
let Player = require("./player");
let Enemy = require("./enemy");
let Deck = require("./deck");
let Card = require("./card");
let Skill = require("./skill");
let Effect = require("./effect");

module.exports = class BattleFactory{
    constructor(input) {
        this.player = new Player("プレイヤー", "", input.playerHp, input.playerPower, input.playerTech, input.playerSpecial, this.makeDeck(input.playerCards), this.makeSkills(input.playerSkills));
        this.enemy = new Enemy(input.enemyName, input.enemyImageName, input.enemyHp, input.enemyPower, input.enemyTech, input.enemySpecial, this.makeDeck(input.enemyCards), this.makeSkills(input.enemySkills));
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

    makeSkills(inputSkills){
        let skills = [];
        for(let skill of inputSkills){
            let effects = [];
            for(let i=1; i<=3; i++){
                if(skill[`effect${i}_category`]){
                    effects.push(new Effect(skill[`effect${i}_category`], skill[`effect${i}_to_self`], skill[`effect${i}_value`]));
                }
            }
            skills.push(new Skill(skill.id, skill.name, skill.cost, skill.reusable, skill.is_defence, effects));
        }
        return skills;
    }
};

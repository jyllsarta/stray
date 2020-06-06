module.exports = class Deck {
    constructor(cards) {
        this.cards = cards;
    }

    findCard(id){
        return this.cards.find((x)=>x.id===id);
    }
};

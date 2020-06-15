module.exports = class Deck {
    constructor(cards) {
        this.cards = cards;

        // いずれもカードIDを保持する
        this.handCardIds = cards.map((x)=>x.id);
        this.discardCardIds = [];
        this.deckCardIds = [];
    }

    currentHands(){
        return this.handCardIds.map((x)=>this.findCard(x));
    }

    consumeCards(cardIds) {
        cardIds.map((id)=>this.consume(id));
    }

    consume(id){
        this.discardCardIds.push(id);
        this.handCardIds = this.handCardIds.filter((x)=>x!==id);
    }

    findCard(id){
        return this.cards.find((x)=>x.id===id);
    }
};

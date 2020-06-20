module.exports = class Character{
    constructor(name, hp, deck) {
        this.name = name;
        this.hp = hp;
        this.deck = deck;
    }

    isAlive(){
        return this.hp > 0;
    }

    atk(){
        return this.deck.cards[this.index].atk();
    }

    powerAt(cardIds){
        const cards = cardIds.map((id)=>this.deck.findCard(id));
        if(cards.length === 0){
            return 0;
        }
        return cards.map((c)=>c.power()).reduce((a,b)=>(a+b));
    }

    techAt(cardIds){
        const cards = cardIds.map((id)=>this.deck.findCard(id));
        if(cards.length === 0){
            return 0;
        }
        return cards.map((c)=>c.tech()).reduce((a,b)=>(a+b));
    }
};

module.exports = class Character{
    constructor(hp, deck) {
        this.hp = hp;
        this.deck = deck;
        this.index = 0; // インデックスをどこでもつかは本実装時に再検討したほうがいいかも
    }

    isAlive(){
        return this.hp > 0;
    }

    atk(){
        return this.deck.cards[this.index].atk();
    }

    draw(){
        this.index++;
        if(this.index >= this.deck.cards.length){
            this.index = 0;
        }
    }
};

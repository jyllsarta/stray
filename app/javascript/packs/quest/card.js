module.exports = class Card {
    constructor(name, str, dex, def, agi) {
        this.name = name;
        this.str = str;
        this.dex = dex;
        this.def = def;
        this.agi = agi;
    }

    atk(){
        return this.str + this.dex + this.def + this.agi;
    }
};

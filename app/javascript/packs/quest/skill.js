module.exports = class Skill {
    constructor(id, name, cost, reusable, is_defence, is_exhaust, effects) {
        this.id = id;
        this.name = name;
        this.cost = cost;
        this.reusable = reusable;
        this.is_defence = is_defence;
        this.is_exhaust = is_exhaust;
        this.effects = effects;
    }

    isMpSufficient(mp){
        if(this.is_exhaust){
            return mp >= 0;
        }
        return mp >= this.cost;
    }
};

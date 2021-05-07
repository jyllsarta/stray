module.exports = class Skill {
    constructor(id, name, description, cost, reusable, is_defence, is_exhaust, is_passive, threshold_hp, effects) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.cost = cost;
        this.reusable = reusable;
        this.is_defence = is_defence;
        this.is_exhaust = is_exhaust;
        this.is_passive = is_passive;
        this.threshold_hp = threshold_hp;
        this.effects = effects;
    }

    isMpSufficient(mp){
        if(this.is_exhaust){
            return mp >= 0;
        }
        return mp >= this.cost;
    }
};

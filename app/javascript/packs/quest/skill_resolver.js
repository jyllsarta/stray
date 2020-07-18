module.exports = class SkillResolver {
    constructor(battle) {
        this.battle = battle;
    }

    resolveSkillEffect(player_side, category, to_self, value) {
        let actor;
        let target;
        if(player_side){
            actor = this.battle.player;
            target = this.battle.enemy;
        }
        else{
            actor = this.battle.enemy;
            target = this.battle.player;
        }

        // 曲芸みたいなことしてんなという自覚はある
        this[`resolve${category}`](actor, target, to_self, value);
    }

    // private

    resolveDamage(actor, target, to_self, value){
        const main = to_self ? target : actor; // 基本相手に作用するので、mainはtarget
        main.damage(value);
    }

    resolveAddHp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.hp += value;
    }

    resolveAddMp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addMp(value);
    }

    resolveAddShield(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addShield(value);
    }

    resolveAddSpDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.specialDamage += value;
    }

    resolveAddPowerDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.powerDamage += value;
    }

    resolveAddTechDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.techDamage += value;
    }
};

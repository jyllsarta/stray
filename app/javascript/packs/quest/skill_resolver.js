module.exports = class
SkillResolver {
    constructor(battle) {
        this.battle = battle;
    }

    resolveSkillEffect(player_side, category, to_self, value, isDefenceSkill) {
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

        if(isDefenceSkill){
            actor.tempBuffs.usedDefenceSkill = true;
        }

        // 曲芸みたいなことしてんなという自覚はある
        this[`resolve${category}`](actor, target, to_self, value);
    }

    // private

    resolveDamage(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.damage(value);
    }

    resolveAddHp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addHp(value);
    }

    resolveAddMp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.addMp(value);
    }

    resolveAddMpOverflow(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.mp += value;
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

    resolveAddPower(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.power += value;
    }

    resolveAddTech(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.tech += value;
    }

    resolveAlterPower(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.powerAlterTo = value;
    }

    resolveAlterTech(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.techAlterTo = value;
    }
};

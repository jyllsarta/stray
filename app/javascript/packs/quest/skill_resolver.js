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

    resolveDamageMp(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.mp -= value;
        if(main.mp < 0){
            main.mp = 0;
        }
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

    resolveAddSpDamageForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.special += value;
    }

    resolveAddPowerDamageForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.power += value;
    }

    resolveAddTechDamageForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tech += value;
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

    resolveAddHandForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.handCardCount += value;
    }

    resolveReduceHandForever(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.handCardCount -= value;
    }

    resolveReduceHand(actor, target, to_self, value){
        const main = to_self ? actor : target;
        main.tempBuffs.handCardCountDelta -= value;
    }

    resolveUpgradeDeck(actor, target, to_self, value){
        const main = to_self ? actor : target;
        for(let card of main.deck.cards){
            card.power += value;
            card.tech += value;
        }
    }

    resolveCalamity(actor, target, to_self, value){
        const main = to_self ? actor : target;
        const multiplier = value;
        for(let skill of main.skills){
            skill.reusable = false;
            for(let effect of skill.effects) {
                effect.value *= multiplier;
            }
        }
    }

    resolveAddPointToWeaker(actor, target, to_self, value){
        const main = to_self ? actor : target;
        const cardIds = to_self ? this.battle.selectingCardIds : this.battle.enemyCardIds;
        if(main.powerAt(cardIds) > main.techAt(cardIds)){
            main.tempBuffs.tech += value;
        }
        else if(main.powerAt(cardIds) < main.techAt(cardIds)){
            main.tempBuffs.power += value;
        }
        else{
            main.tempBuffs.power += value;
            main.tempBuffs.tech += value;
        }
    }
};

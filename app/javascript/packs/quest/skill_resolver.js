module.exports = class
SkillResolver {
    constructor(battle) {
        this.battle = battle;
    }

    resolveSkillEffect(player_side, category, to_self, value, skill, isDefenceSkill) {
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
        this[`resolve${category}`](actor, target, to_self, value, skill);
    }

    // private

    resolveAddState(actor, target, to_self, value, skill){
        const owner = to_self ? actor : target;
        const opponent = to_self ? target : actor;
        this.battle.addStateToCharacter(owner, opponent, value);
    }

    resolveDamage(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.damage(value);
    }

    resolveDamagePercent(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const dmg = Math.floor(main.hp_max * value / 100);
        main.damage(dmg);
    }

    resolveMuramasa(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const dmg = actor.hp_max - actor.hp;
        if(dmg <= 0){
            return;
        }
        main.damage(dmg);
    }

    resolveFireDamage(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const stateIds = [2007, 2019]; // ブレイクのステートID
        if(stateIds.some(stateId=>main.findStateById(stateId))){
            value *= 2;
        }
        main.damage(value);
    }

    resolveStormDamage(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const opponent = to_self ? target : actor;
        const stateId = 2010; // ストーム状態のステートID
        // ストームダメージを食らう側から見た敵 = (大抵は)プレイヤー がストームのステートを持っているかどうか
        const storm = opponent.findStateById(stateId);
        const additionalDamage = storm ? storm.condition.value : 0;

        main.damage(value + additionalDamage);
    }

    // ストームを持っていなければ付与、持っていればスタックを1増加
    resolveCheckStorm(actor, target, to_self, value, skill){
        const owner = to_self ? actor : target;
        const opponent = to_self ? target : actor;
        const stateId = 2010; // ストーム状態のステートID
        const storm = owner.findStateById(stateId)
        if(!storm){
            this.battle.addStateToCharacter(owner, opponent, stateId);
        }
        else{
            storm.condition.value += 1;
        }
    }

    resolveAddCost(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        skill.cost += value;
    }

    resolveAddHp(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.addHp(value);
    }

    resolveAddMp(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.addMp(value);
    }

    resolveSetHp(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.setHp(value);
    }

    resolveSetMp(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.setMp(value);
    }

    resolveAddHpOverflow(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.hp += value;
    }

    resolveAddMpOverflow(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.mp += value;
    }

    resolveDamageMp(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.damageMp(value);
    }

    resolveAddShield(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.addShield(value);
    }

    resolveAddSpDamage(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.specialDamage += value;
    }

    resolveAddPowerDamage(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.powerDamage += value;
    }

    resolveAddTechDamage(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.techDamage += value;
    }

    resolveAddSpDamageForever(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.special += value;
    }

    resolveAddPowerDamageForever(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.power += value;
    }

    resolveAddTechDamageForever(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tech += value;
    }

    resolveAddPower(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.power += value;
    }

    resolveAddTech(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.tech += value;
    }

    resolveAlterPower(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.powerAlterTo = value;
    }

    resolveAlterTech(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.techAlterTo = value;
    }

    resolveAddHandForever(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.handCardCount += value;
    }

    resolveReduceHandForever(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.handCardCount -= value;
    }

    resolveReduceHand(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.tempBuffs.handCardCountDelta -= value;
    }

    resolveUpgradeDeck(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        for(let card of main.deck.cards){
            card.power += value;
            card.tech += value;
        }
    }

    resolveCalamity(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const multiplier = value;
        for(let skill of main.skills){
            for(let effect of skill.effects) {
                if(effect.category === "AddState"){
                    continue;
                }
                effect.value *= multiplier;
            }
        }
        // カラミティ本体のID直接指定
        this.battle.addState(to_self, 2001);
    }

    resolveBrossom(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;

        if(main.hp !== 1){
            return;
        }

        //どうせガチガチ結合スキルなので、プレイヤー専用前提で作っちゃう
        if(this.battle.powerMeetResult() !== "win" || this.battle.techMeetResult() !== "win"){
            return;
        }

        for(let skill of main.skills){
            if(skill.id === 10410){ // ガチガチ結合いやー！ 自身は再使用可能にならない
                continue;
            }
            if(skill.is_passive){ // パッシブに∞つくのも邪魔なのでつけない
                continue;
            }
            skill.reusable = true;
        }
        main.setMp(200);
        main.hp_max= 1;
    }

    resolveAddPointToWeaker(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const cardIds = main.selectingCardIds;
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

    resolveCrossingCosmos(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const cardIds = main.selectingCardIds;
        if(main.powerAt(cardIds) > main.techAt(cardIds)){
            const diff = Math.max( target.techAt(target.selectingCardIds) - main.techAt(cardIds), 0);
            main.tempBuffs.tech += diff;
        }
        else if(main.powerAt(cardIds) < main.techAt(cardIds)){
            const diff = Math.max( target.powerAt(target.selectingCardIds) - main.powerAt(cardIds), 0);
            main.tempBuffs.power += diff;
        }
        else{
            const diff = Math.max( target.techAt(target.selectingCardIds) - main.techAt(cardIds), 0);
            const diff2 = Math.max( target.powerAt(target.selectingCardIds) - main.powerAt(cardIds), 0);
            const minimum = Math.min(diff, diff2);
            main.tempBuffs.tech += minimum;
            main.tempBuffs.power += minimum;
        }
    }

    resolveReduceMaxHp(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        main.hp -= value;
        main.hp_max -= value;
    }

    resolveCrashSelectingCardA(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const cardId = main.selectingCardIds[0];
        let card = main.deck.findCard(cardId);
        card.name = "破壊された！";
        card.power = 0;
        card.tech = 0;
    }

    resolveCrashSelectingCardB(actor, target, to_self, value, skill){
        const main = to_self ? actor : target;
        const cardId = main.selectingCardIds[1];
        let card = main.deck.findCard(cardId);
        card.name = "破壊された！";
        card.power = 0;
        card.tech = 0;
    }
};

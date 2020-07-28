const Constants = {
  window: {
    ground: {
      left: -200,
      right: 200,
      // 1フレームごとに [-delta, delta] の範囲でスピードを加算する
      speedDelta: 0.05,
      // speed < これ なら静止状態として扱う
      staticStateThreshold: 0.05,
    },
  },
  character: {
    // constants.yml とそれぞれ重複定義しているので注意...(つらい)
    defaultParameters: {
      rank1: {
        str: 10,
        dex: 10,
        def: 10,
        agi: 10,
      },
      rank2: {
        str: 1200,
        dex: 1200,
        def: 1200,
        agi: 1200,
      },
      rank3: {
        str: 7500,
        dex: 7500,
        def: 7500,
        agi: 7500,
      },
      rank4: {
        str: 50000,
        dex: 50000,
        def: 50000,
        agi: 50000,
      },
    },
    expMax: 1000,
  },
  log: {
    maxLength: 300,
  },
  item: {
    rankFactor: 1.4,
    rarityFactor: {
      1: 1.0,
      2: 1.1,
      3: 1.3,
      4: 1.65,
      5: 2.2,
    },
  },
  event: {
    battle: {
      enemyRankFactor: 0.98,
      enemyRankGeta: 4,
    },
  },
  dungeon: {
    bossFloorFrequency: 100,
    bossLoseRewindFloor: 3,
  },
  // 次回イベント発生予測時間から何秒バッファをもたせてからリクエストするか
  nextEventDelaySeconds: 2,
  itemsPerPage: 50,
  maxEquipCount: 4,
  eventIllustShowMilliSeconds: 2000,
  battleCharacter: {
    imageLibrary: {
      spica: {
        normal:  'normal',
        attack:  'attack',
        draw:    'draw',
        lose:    'lose',
        default: 'normal',
      },
      tirol: {
        normal:  'tirol',
        magic:   'magic',
        default: 'normal',
      },
      maoh: {
        normal:  'normal',
        lose:    'lose',
        magic:   'magic',
        default: 'normal',
      },
      faily: {
        normal:  'normal',
        default: 'normal',
      },
      kani: {
        normal:  'normal',
        default: 'normal',
      },
    }
  }
};
export default Constants;
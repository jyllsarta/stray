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
  welcomeMessage: "スピカとチロルへようこそ！\nまずは二人の冒険を見守りつつ、装備を拾ったらつけてあげてね。",
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
        str: 500,
        dex: 500,
        def: 500,
        agi: 500,
      },
      rank3: {
        str: 3500,
        dex: 3500,
        def: 3500,
        agi: 3500,
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
    rankFactor: 1.015,
    rarityFactor: {
      1: 1.0,
      2: 1.1,
      3: 1.3,
      4: 1.65,
      5: 2.2,
    },
  },
  dungeon: {
    bossFloorFrequency: 100,
    bossLoseRewindFloor: 3,
  },
  achievements: {
    ids: {
      clickFieldCharacter: 25,
      signIn: 26,
      openLog: 27,
    }
  },
  // 次回イベント発生予測時間から何秒バッファをもたせてからリクエストするか
  nextEventDelaySeconds: 2,
  itemsPerPage: 50,
  maxEquipCount: 4,
  eventIllustShowMilliSeconds: 2000,
  enemy: {
    plusValueThreshold: 30
  },
  battleCharacter: {
    imageLibrary: {
      spica: {
        normal:  'normal',
        attack:  'attack',
        attack2:  'attack2',
        attack3:  'attack3',
        draw:    'draw',
        lose:    'lose',
        default: 'normal',
        scaleType: 1, // is normal
      },
      tirol: {
        normal:  'normal',
        magic:   'magic',
        default: 'normal',
        scaleType: 1,
      },
      maoh: {
        normal:  'normal',
        lose:    'lose',
        magic:   'magic',
        default: 'normal',
        scaleType: 1,
      },
      faily: {
        normal:  'normal',
        default: 'normal',
        scaleType: 3, // is tiny and hovering
      },
      faily_eleki: {
        normal:  'normal',
        default: 'normal',
        scaleType: 3,
      },
      faily_book: {
        normal:  'normal',
        default: 'normal',
        scaleType: 3,
      },
      faily_queen: {
        normal:  'normal',
        default: 'normal',
        scaleType: 3,
      },
      kani: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2, // is mini
      },
      kani_gold: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      kani_mage: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      kani_white: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      nya: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      nya_black: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      nya_blue: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      nya_king: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      gob: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      gob_rance: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      gob_mage: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
      gob_fighter: {
        normal:  'normal',
        default: 'normal',
        scaleType: 2,
      },
    }
  }
};
export default Constants;
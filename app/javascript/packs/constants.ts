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
      str: 10,
      dex: 10,
      vit: 10,
      agi: 10,
    },
    expMax: 1000,
  },
  log: {
    maxLength: 50,
  },
  item: {
    rankFactor: 1.01,
    rarityFactor: {
      1: 1.0,
      2: 1.1,
      3: 1.3,
      4: 1.5,
      5: 1.8,
    },
    maxRankUpCost: 9999,
  },
  dungeon: {
    bossFloorFrequency: 100,
    bossLoseRewindFloor: 3,
    lastDungeonId: 7,
  },
  achievements: {
    ids: {
      clickFieldCharacter: 101,
      signIn: 102,
      openLog: 103,
    }
  },
  // 次回イベント発生予測時間から何秒バッファをもたせてからリクエストするか
  nextEventDelaySeconds: 2,
  itemsPerPage: 20,
  maxEquipCount: 4,
  eventIllustShowMilliSeconds: 2000,
  enemy: {
    // サーバと値を共有してるので注意
    plusValueThreshold: 0.7,
    lastBossEnemyId: 705,
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
      },
      tirol: {
        normal:  'normal',
        magic:   'magic',
        default: 'normal',
      },
      maoh: {
        normal:  'normal',
        lose:    'lose',
        magic:   'magic',
        default: 'normal',
      },
      default: {
        normal:  'normal',
        default: 'normal',
      }
    }
  }
};
export default Constants;
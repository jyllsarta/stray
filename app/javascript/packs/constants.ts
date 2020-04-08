const Constants = {
  window: {
    ground: {
      left: -200,
      right: 200,
    }
  },
  character: {
    // constanys.yml とそれぞれ重複定義しているので注意...(つらい)
    defaultParameters: {
      spica: {
        str: 10,
        dex: 10,
        def: 10,
        agi: 10,  
      },
      tirol: {
        str: 10,
        dex: 10,
        def: 10,
        agi: 10,  
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
  nextEventDelaySeconds: 3,
  itemsPerPage: 50,
  maxEquipCount: 4,
  eventIllustShowMilliSeconds: 2000,
};
export default Constants;
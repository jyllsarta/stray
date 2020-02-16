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
    }
  },
  // 次回イベント発生予測時間から何秒バッファをもたせてからリクエストするか
  nextEventDelaySeconds: 3,
  itemsPerPage: 10,
  maxEquipCount: 4,
  eventIllustShowMilliSeconds: 2000,
};
export default Constants;
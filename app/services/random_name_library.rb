class RandomNameLibrary
  def self.random_name(type, seeded_random)
    return nil if type == :boss # ボスは本来の名前をそのまま戻させる
    name = seeded_random.sample(library[type])
    prefix = seeded_random.sample(prefixes[type])
    "#{prefix}#{name}"
  end

  def self.prefixes
    {
      gob: [
        "ゴブリン・",
      ],
      faily: [
        "透羽",
        "風羽",
        "震羽",
        "幽羽",
        "硬羽",
        "銀羽",
        "原羽",
        "踊羽",
      ],
      nya: [
        "天猫",
        "駄猫",
        "日猫",
        "夏猫",
      ],
      magi: [
        "鍵魔",
        "錠魔",
        "裁魔",
        "上魔",
      ],
      leaf: [
        "洋葉・",
        "狂葉・",
        "幼葉・",
        "響葉・",
      ],
      core: [
        "核/",
      ],
      kani: [
        "鉄殻",
        "硬殻",
        "爪殻",
      ],
      ghost: [
        "現霊",
        "静霊",
        "水霊",
        "推霊",
      ],
      gorem: [
        "石晶",
        "石雄",
        "石城",
      ],
      soldier: [
        "争鎧",
        "戦鎧",
        "終鎧",
        "黒鎧",
      ]
    }
  end

  def self.library
    {
      gob: [
        "ベリス",
        "ドルジ",
        "ボルド",
        "カウン",
        "モマド",
        "ギスゴ",
        "ゲルト",
        "ハキム",
        "ロイド",
        "ドルガ",
        "ゴラム",
      ],
      faily: [
        "フレイヤ",
        "エステル",
        "パニーラ",
        "カリータ",
        "テューラ",
        "アニトラ",
        "イェシカ",
        "ヴェーラ",
        "スヴェア",
        "スティナ",
        "アネッテ",
      ],
      nya: [
        "ロー",
        "ルリ",
        "キキ",
        "ラァ",
        "ヌー",
        "ペケ",
        "アロ",
        "マヨ",
        "サバ",
        "イロ",
      ],
      magi: [
        "フェリシタス",
        "クリスティネ",
        "エストレジャ",
        "バレンティア",
        "ベレンガリア",
        "アドラシオン",
        "ヴィルヒニア",
        "フェリシダド",
        "エミグディア",
        "フランシスカ",
      ],
      leaf: [
        "ユーノ",
        "ヨーリ",
        "ピーア",
        "アーラ",
        "リーネ",
        "ソーン",
        "ミーナ",
        "ニーカ",
        "ナーレ",
        "ユーユ",
      ],
      core: [
        "カーマピーホ",
        "ポーベアグニ",
        "ブンジスパタ",
        "アトロエネソ",
        "アドローサフ",
        "マリナチウボ",
        "ヘカトヤルダ",
        "アシュスゲル",
        "サラスケプリ",
        "ラウニイギル",
      ],
      kani: [
        "双爪",
        "撃爪",
        "羅爪",
        "鋭爪",
        "闇爪",
        "複爪",
        "剣爪",
        "力爪",
        "金爪",
        "銀爪",
      ],
      ghost: [
        "イラタバ",
        "プァルナ",
        "ネローク",
        "チャルー",
        "マクノビ",
        "ケプリン",
        "コヨニァ",
        "サルーナ",
        "メフィワ",
        "フロリサ",
      ],
      gorem: [
        "デスティン",
        "アルティス",
        "エウカラム",
        "ハーヴェイ",
        "トレイシー",
        "ファブリス",
        "ミルチェア",
        "ヴィタリー",
        "ビセーピィ",
        "オーティス",
      ],
      soldier: [
        "ケピドゥ",
        "バーギン",
        "レクセル",
        "アドルノ",
        "アールン",
        "ハルミニ",
        "ヨントゥ",
        "リーター",
        "カルジア",
        "フロート",
      ],
    }
  end
end

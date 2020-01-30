# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Item.delete_all

Item.create([
  {
    id: 1,
    name: "木の棒",
    str: 1,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "木の棒だ。",
    rarity: 1,
  },
  {
    id: 2,
    name: "鉄の盾",
    str: 2,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 2,
  },
  {
    id: 3,
    name: "ネバネバ",
    str: 3,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 3,
  },
  {
    id: 4,
    name: "ポーション",
    str: 4,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 4,
  },
  {
    id: 5,
    name: "蟹",
    str: 5,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 1,
  },
  {
    id: 6,
    name: "アイアンソード",
    str: 6,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 1,
  },
  {
    id: 7,
    name: "パフェ",
    str: 7,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 1,
  },
  {
    id: 8,
    name: "地図",
    str: 8,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 1,
  },
  {
    id: 9,
    name: "たこ",
    str: 9,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 1,
  },
  {
    id: 10,
    name: "しろこの銀看板",
    str: 10,
    dex: 2,
    def: 3,
    agi: 4,
    flavor_text: "まだ仮のフレーバーテキストだ。",
    rarity: 1,
  }
])

puts "seeded!"
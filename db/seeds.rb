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
    name: "木の棒",
    str: 1,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "鉄の盾",
    str: 2,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "ネバネバ",
    str: 3,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "ポーション",
    str: 4,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "蟹",
    str: 5,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "アイアンソード",
    str: 6,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "パフェ",
    str: 7,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "地図",
    str: 8,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "たこ",
    str: 9,
    dex: 2,
    def: 3,
    agi: 4
  },
  {
    name: "しろこの銀看板",
    str: 10,
    dex: 2,
    def: 3,
    agi: 4
  }
])

puts "seeded!"
require 'rails_helper'

RSpec.describe ProfileBuilder, type: :model do
  let(:builder){ ProfileBuilder.new(user) }
  let(:user){ User.create }
  let!(:item){ create(:item, name: "スピカのアイテム") }
  let!(:user_item){ create(:user_item, user: user, item: item)}
  let!(:item2){ create(:item, name: "チロルのアイテム", rarity: 3) }
  let!(:user_item2){ create(:user_item, user: user, item: item2)}
  let!(:achievement_rank){ create(:achievement_rank) }

  before do
    user.characters.spica.first.force_set_equips([item.id])
    user.characters.tirol.first.force_set_equips([item2.id])
  end

  describe "#extract" do
    subject{ builder.extract }

    it "returns formatted hash" do
      expect(subject).to match_json_expression({
                                                   parameters: {
                                                       spica: {
                                                           str: Integer,
                                                           dex: Integer,
                                                           vit: Integer,
                                                           agi: Integer,
                                                       },
                                                       tirol: {
                                                           str: Integer,
                                                           dex: Integer,
                                                           vit: Integer,
                                                           agi: Integer,
                                                       },
                                                   },
                                                   equips: {
                                                       spica: [
                                                           {
                                                               name: "スピカのアイテム",
                                                               rarity: 1,
                                                           }
                                                       ],
                                                       tirol: [
                                                           {
                                                               name: "☆チロルのアイテム",
                                                               rarity: 3,
                                                           }
                                                       ],
                                                   },
                                                   achievements: {
                                                       total_coin: Integer,
                                                       deepest_floor: Integer,
                                                       total_play_time: Integer,
                                                       unique_item_count: Integer,
                                                       total_event: Integer,
                                                       won_enemy_count: Integer,
                                                       relics: Integer,
                                                       cleared_achievements: Integer,
                                                   },
                                                   total_rank: {
                                                        rank: String,
                                                        description: String,
                                                    }
                                               })
    end
  end
end

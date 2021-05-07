# == Schema Information
#
# Table name: quests
#
#  id                    :bigint           not null, primary key
#  description           :string(255)
#  name                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  field_effect_state_id :integer
#  parent_quest_id       :integer
#

require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe "#won_enemy_count" do
    let(:quest) { create(:quest) }
    let(:enemy) { create(:enemy, quest: quest) }
    let(:user) { create(:user) }
    subject { quest.won_enemy_count(user) }

    context "not cleared" do
      it "0" do
        expect(subject).to eq(0)
      end
    end

    context "cleared" do
      let!(:won_enemy){ create(:user_won_enemy, user: user, enemy: enemy) }
      it "1" do
        expect(subject).to eq(1)
      end
    end
  end

  describe "#cleared?" do
    let(:quest) { create(:quest) }
    let!(:enemy1) { create(:enemy, quest: quest) }
    let!(:enemy2) { create(:enemy, quest: quest, is_boss: true) }
    let!(:enemy3) { create(:enemy, quest: quest, is_boss: false) } # ボスじゃないのでクリア条件に影響しない
    let(:user) { create(:user) }
    subject { quest.cleared?(user) }

    let!(:won_enemy1){ create(:user_won_enemy, user: user, enemy: enemy1) }

    context "boss not cleared" do
      it "false" do
        expect(subject).to eq(false)
      end
    end

    context "boss cleared" do
      let!(:won_enemy2){ create(:user_won_enemy, user: user, enemy: enemy2) }
      it "true" do
        expect(subject).to eq(true)
      end
    end
  end

  describe "#visible?" do
    let(:quest) { create(:quest) }
    let!(:enemy) { create(:enemy, quest: quest, is_boss: true) }
    let(:user) { create(:user) }

    let(:child_quest) { create(:quest, parent_quest_id: quest.id) }
    subject { child_quest.visible?(user) }


    context "parent not cleared" do
      it "false" do
        expect(subject).to eq(false)
      end
    end

    context "parent quest cleared" do
      let!(:won_enemy){ create(:user_won_enemy, user: user, enemy: enemy) }
      it "true" do
        expect(subject).to eq(true)
      end
    end
  end
end

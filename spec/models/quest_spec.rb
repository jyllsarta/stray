# == Schema Information
#
# Table name: quests
#
#  id              :bigint           not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_quest_id :integer
#

require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe "#cleared_count" do
    let(:quest) { create(:quest) }
    let(:enemy) { create(:enemy, quest: quest) }
    let(:user) { create(:user) }
    subject { quest.cleared_count(user) }

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
end

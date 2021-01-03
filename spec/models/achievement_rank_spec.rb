# == Schema Information
#
# Table name: achievement_ranks
#
#  id          :bigint           not null, primary key
#  description :string(255)      not null
#  rank        :string(255)      not null
#  step_count  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_achievement_ranks_on_step_count  (step_count) UNIQUE
#

require 'rails_helper'

RSpec.describe AchievementRank, type: :model do
  describe "#rank_at" do
    subject { AchievementRank.rank_at(rank) }

    # 他のテストで作ったレコードに引っ張られちゃうので全部消す
    before do
      AchievementRank.delete_all
    end
  
    let!(:achievement_rank){ create(:achievement_rank, step_count: 0) }
    let!(:achievement_rank2){ create(:achievement_rank, step_count: 20) }
  
    context do
      let(:rank){ 0 }
      it "returns collect model object" do
        expect(subject.id).to eq(achievement_rank.id)
      end
    end
    context do
      let(:rank){ 19 }
      it "returns collect model object" do
        expect(subject.id).to eq(achievement_rank.id)
      end
    end
    context do
      let(:rank){ 20 }
      it "returns collect model object" do
        expect(subject.id).to eq(achievement_rank2.id)
      end
    end
    context do
      let(:rank){ 1000 }
      it "returns collect model object" do
        expect(subject.id).to eq(achievement_rank2.id)
      end
    end
  end
end

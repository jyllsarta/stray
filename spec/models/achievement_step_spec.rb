# == Schema Information
#
# Table name: achievement_steps
#
#  id             :bigint           not null, primary key
#  description    :string(255)      not null
#  progress       :integer          not null
#  title          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  achievement_id :bigint
#
# Indexes
#
#  index_achievement_steps_on_achievement_id  (achievement_id)
#

require 'rails_helper'

RSpec.describe AchievementStep, type: :model do
  let!(:user){ create(:user) }
  let!(:achievement){ create(:achievement) }
  let!(:step){ create(:achievement_step, achievement: achievement, progress: 100) }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: progress) }
  let!(:user_achievement_step){ create(:user_achievement_step, user: user, achievement_step: step) }
  describe "#cleared?" do
    subject { step.cleared?(user) }
    context "not cleared" do
      let(:progress){ 99 }
      it "returns false" do
        expect(subject).to eq(false)
      end
    end
    context "cleared" do
      let(:progress){ 100 }
      it "returns false" do
        expect(subject).to eq(true)
      end
    end
  end
end

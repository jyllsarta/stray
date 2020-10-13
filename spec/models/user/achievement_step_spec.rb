# == Schema Information
#
# Table name: user_achievement_steps
#
#  id                  :bigint           not null, primary key
#  received            :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  achievement_step_id :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_user_achievement_steps_on_achievement_step_id  (achievement_step_id)
#  index_user_achievement_steps_on_user_id              (user_id)
#

require 'rails_helper'

RSpec.describe User::AchievementStep, type: :model do
  let!(:dungeon){ create(:dungeon) }
  let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
  let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
  let!(:user){ create(:user) }
  let!(:user_status){ create(:user_status, user: user) }
  let!(:achievement){ create(:achievement) }
  let!(:step){ create(:achievement_step, achievement: achievement, progress: 100) }
  let!(:step_reward){ create(:achievement_step_reward, achievement_step: step) }
  let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: progress) }
  let!(:user_achievement_step){ create(:user_achievement_step, user: user, achievement_step: step, received: received) }
  describe "#receive!" do
    subject { user_achievement_step.receive! }
    context "ok" do
      let(:received){ false }
      let(:progress){ 100 }
      it "succeeds" do
        expect{subject}.to_not raise_error
      end
      it "receives reward" do
        expect{subject}.to change(user.status, :coin).by(100)
      end
    end
    context "already received" do
      let(:received){ true }
      let(:progress){ 100 }
      it "receives reward" do
        expect{subject}.to raise_error(User::AchievementStep::AlreadyReceived)
      end
    end
    context "not cleared" do
      let(:received){ false }
      let(:progress){ 99 }
      it "receives reward" do
        expect{subject}.to raise_error(User::AchievementStep::NotClearedYet)
      end
    end
  end
end

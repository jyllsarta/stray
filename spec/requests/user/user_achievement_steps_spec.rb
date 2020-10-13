require 'rails_helper'

RSpec.describe "User::AchievementStep", type: :request do

  describe "POST /users/:user_id/user_achievement_steps/receive_reward" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let!(:achievement){ create(:achievement) }
    let!(:step){ create(:achievement_step, achievement: achievement, progress: 100) }
    let!(:step_reward){ create(:achievement_step_reward, achievement_step: step) }
    let!(:user_achievement){ create(:user_achievement, user: user, achievement: achievement, progress: 100) }
    let!(:user_achievement_step){ create(:user_achievement_step, user: user, achievement_step: step, received: false) }
    let(:do_post) { post receive_reward_user_user_achievement_steps_path(user_id: -1) + ".json", params: params }

    context "succeeds" do
      let(:params) do
        {
          achievement_step_id: step.id
        }
      end
      subject do
        do_post
        response
      end

      it "returns formatted hash" do
        expect(subject).to have_http_status(204)
      end
    end
  end
end
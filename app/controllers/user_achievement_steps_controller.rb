class UserAchievementStepsController < ApplicationController
  def receive_reward
    current_user.achievement_steps.find_or_initialize_by(achievement_step_id: params[:achievement_step_id]).receive!
    head 204
  end
end

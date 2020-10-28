class AchievementsController < ApplicationController
  def complete
    current_user.achievement_logger.post(Achievement::Event::ClientComplete.new(params[:event_name]))
    head 204
  end
end


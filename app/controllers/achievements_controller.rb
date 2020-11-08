class AchievementsController < ApplicationController
  def complete
    current_user.achievement_logger.post(Achievement::Event::ClientComplete.new(params[:event_name]))
    head 204
  end

  def cache
    @cache = Achievement::StepClearedCache.read(current_user)
    # GET で delete するってどういうこっちゃねん！って感じするけど、「未読」を返すAPIなのでいいでしょう
    Achievement::StepClearedCache.delete(current_user)
  end
end

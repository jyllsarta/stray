class ApplicationController < ActionController::Base
  after_action :commit_achievement
  class NoToken < StandardError; end

  def current_user
    raise NoToken if unauthorized?
    @_user ||= User::AccessToken.find_user_by_token!(request.headers["X-AccessToken"])
  end

  private

  def commit_achievement
    return if unauthorized?
    current_user.achievement_logger.commit
  end

  def unauthorized?
    request.headers["X-AccessToken"].blank? || request.headers["X-AccessToken"] == "undefined"
  end
end

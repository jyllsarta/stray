class ApplicationController < ActionController::Base
  before_action :set_raven_context
  class NoToken < StandardError; end

  def current_user
    raise NoToken if request.headers["X-AccessToken"].blank? || request.headers["X-AccessToken"] == "undefined"
    @_user ||= User::AccessToken.find_user_by_token!(request.headers["X-AccessToken"])
  end

  private

  def set_raven_context
    return if request.headers["X-AccessToken"].blank? || request.headers["X-AccessToken"] == "undefined"
  end
end

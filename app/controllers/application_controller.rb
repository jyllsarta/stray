class ApplicationController < ActionController::Base
  before_action :set_raven_context
  class NoToken < StandardError; end

  def current_user
    raise NoToken if request.headers["X-AccessToken"].blank?
    @_user ||= User::AccessToken.find_user_by_token!(request.headers["X-AccessToken"])
  end

  private

  def set_raven_context
    return if request.headers["X-AccessToken"].blank?
    Raven.user_context(id: current_user.id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url) # logs all params and request parameters
  end
end

class ApplicationController < ActionController::Base
  class NoToken < StandardError; end

  def current_user
    raise NoToken if request.headers["X-AccessToken"].blank?
    @_user ||= User::AccessToken.find_user_by_token!(request.headers["X-AccessToken"])
  end
end

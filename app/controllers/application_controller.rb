class ApplicationController < ActionController::Base
  def current_user
    @_user ||= User::AccessToken.find_user_by_token(request.headers["X-AccessToken"])
  end
end

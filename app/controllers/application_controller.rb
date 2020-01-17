class ApplicationController < ActionController::Base

  def current_user
    @_user ||= User::AccessToken.find_user_by_token!(request.headers["X-AccessToken"])
  rescue ActiveRecord::RecordNotFound
    render json: {success: false, message: "invalid access token."}, status: :not_found
  end
end

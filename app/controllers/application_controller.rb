class ApplicationController < ActionController::Base
  class NoToken < StandardError; end

  def current_user
    raise NoToken if request.headers["X-AccessToken"].blank?
    @_user ||= User::AccessToken.find_user_by_token!(request.headers["X-AccessToken"])
  # TODO: 共通エラーハンドラを定義
  rescue ActiveRecord::RecordNotFound
    render json: {success: false, message: "invalid access token."}, status: :not_found
  rescue NoToken
    render json: {success: false, message: "no access token."}, status: :not_found
  end
end

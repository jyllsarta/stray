class UsersController < ApplicationController
  def create
    @user = User.create
    @access_token = User::AccessToken.generate(@user)
  end
  def events
  end
  def status
    @user = current_user
  end
  def register_name
    current_user.register_name(name: params[:name], password: params[:password])
  rescue User::AlreadyUsed
    render json: {success: false, message: "name is already used."}, status: :bad_request
  end
end

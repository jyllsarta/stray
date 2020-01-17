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

  def regenerate_token
    @access_token = User.regenerate_token(name: params[:name], password: params[:password])
    @user = User.find_by!(name: params[:name])
  rescue ActiveRecord::RecordNotFound
    render json: {success: false, message: "invalid name or password."}, status: :not_found
  end
end

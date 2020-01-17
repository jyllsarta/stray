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
end

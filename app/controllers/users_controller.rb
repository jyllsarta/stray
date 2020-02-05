class UsersController < ApplicationController
  def create
    @user = User.create
    @access_token = User::AccessToken.generate(@user)
  end

  def events
    @events = EventFacade.new.get_and_execute_latest_events!(current_user)
    @next_event_at = current_user.status.next_event_at
  end

  def status
    @user = current_user
    @status = current_user.status
    @items = current_user.items.map do |item|
      [item.item_id, item.attributes]
    end.to_h
    @spica_equips = current_user.characters.spica.first.equip_item_ids.compact
    @tirol_equips = current_user.characters.tirol.first.equip_item_ids.compact
  end

  def register_name
    current_user.register_name(name: params[:name], password: params[:password])
  rescue User::AlreadyUsed
    render json: {success: false, message: "このユーザ名は使われています。"}, status: :bad_request
  rescue User::EmptyName
    render json: {success: false, message: "名前が空です。"}, status: :bad_request
  rescue User::EmptyPassword
    render json: {success: false, message: "パスワードが空です。"}, status: :bad_request
  end

  def regenerate_token
    @access_token = User.regenerate_token(name: params[:name], password: params[:password])
    @user = User.find_by!(name: params[:name])
  rescue ActiveRecord::RecordNotFound
    render json: {success: false, message: "ユーザ名かパスワードが違います。"}, status: :not_found
  end
end

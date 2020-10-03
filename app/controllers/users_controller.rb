class UsersController < ApplicationController
  before_action :verify_session, only: :events

  def create
    @user = User.create
    @access_token = User::AccessToken.generate(@user)
  end

  def events
    @events = EventFacade.new.get_and_execute_latest_events!(current_user)
    @next_event_at = current_user.status.next_event_at
    @after_velocity = current_user.status.velocity
  end

  def resurrect
    current_user.status.manual_resurrect!
    render json: {success: true}, status: :ok
  end

  def status
    @user = current_user
    @status = current_user.status
    @items = current_user.items.map do |item|
      [item.item_id, item.attributes]
    end.to_h
    @relics = current_user.relics.map do |relic|
      [relic.relic_id, relic.attributes]
    end.to_h
    @dungeon_progresses = current_user.status.dungeon_progresses.map do |dp|
      [dp.dungeon_id, dp.attributes]
    end.to_h
    @spica_equips = current_user.characters.spica.first.equip_item_ids.compact
    @tirol_equips = current_user.characters.tirol.first.equip_item_ids.compact
    @quest_battle_parameters = {
      hp: 5 + current_user.status.quest_battle_additional_hp,
      power: 1,
      tech: 1,
      special: 1
    }
  end

  def deck
    @user = current_user
    @class_cards = DeckBuilder.new(current_user).class_cards
    @item_cards = DeckBuilder.new(current_user).item_cards
  end

  def won_enemies
    @user = current_user
  end

  def register_name
    current_user.register_name(name: params[:name], password: params[:password])
  end

  def regenerate_token
    @access_token = User.regenerate_token(name: params[:name], password: params[:password])
    @user = User.find_by!(name: params[:name])
  end

  def switch_dungeon
    current_user.status.switch_dungeon!(params[:dungeon_id].to_i, params[:depth].to_i)
    render json: {success: true}, status: :ok
  end

  private

  def verify_session
    request_session_id = request.headers["X-SessionId"]
    session_started_at = request.headers["X-SessionStartedAt"]

    session_id = SessionId.new(current_user)
    session_id.verify!(request_session_id, session_started_at)
    session_id.write(request_session_id, session_started_at)
  end
end

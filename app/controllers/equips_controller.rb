class EquipsController < ApplicationController
  def edit
    ActiveRecord::Base.transaction do
      current_user.characters.spica.first.force_set_equips(params[:spica])
      current_user.characters.tirol.first.force_set_equips(params[:tirol])
      raise User::DuplicateEquips unless current_user.equip_no_duiplicate?
    end
    render json: {success: true}, status: :ok
  rescue User::DuplicateEquips
    render json: {success: false, message: "装備が重複しています。"}, status: :bad_request
  end
end

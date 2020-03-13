class EquipsController < ApplicationController
  def edit
    ActiveRecord::Base.transaction do
      current_user.characters.spica.first.force_set_equips(params[:spica])
      current_user.characters.tirol.first.force_set_equips(params[:tirol])
      raise User::DuplicateEquips unless current_user.equip_no_duplicate?
    end
  render json: {success: true}, status: :ok
  end
end

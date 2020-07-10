class SkillsController < ApplicationController
  def index
    @user_skills = current_user.skills
  end

  def equip
    render json: {success: true }, status: :ok
  end
end

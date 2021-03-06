class SkillsController < ApplicationController
  def index
    @user_skills = current_user.skills.preload(:skill).order(skill_id: :asc)
  end

  def equip
    User::Skill.equip_skill!(current_user, params[:skill_ids])
    render json: {success: true }, status: :ok
  end
end

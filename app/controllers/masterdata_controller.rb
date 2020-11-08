class MasterdataController < ApplicationController
  def index
    @items = Item.all.index_by(&:id)
    @dungeons = Dungeon.all.index_by(&:id)
    @relics = Relic.all.index_by(&:id)
    @skills = Skill.all.index_by(&:id)
    @achievement_steps = AchievementStep.preload(:achievement_step_rewards).all.map do |step|
      attributes = step.attributes.merge({rewards: step.rewards})
      [step.id, attributes]
    end.to_h
  end
end

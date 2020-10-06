class MasterdataController < ApplicationController
  def index
    @items = Item.all.index_by(&:id)
    @dungeons = Dungeon.all.index_by(&:id)
    @relics = Relic.all.index_by(&:id)
    @skills = Skill.all.index_by(&:id)
    @achievement_steps = AchievementStep.all.index_by(&:id)
  end
end

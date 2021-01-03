# == Schema Information
#
# Table name: achievement_ranks
#
#  id          :bigint           not null, primary key
#  description :string(255)      not null
#  rank        :string(255)      not null
#  step_count  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_achievement_ranks_on_step_count  (step_count) UNIQUE
#

class AchievementRank < ApplicationRecord
  def self.rank_at(cleared_step_count)
    where("step_count <= #{cleared_step_count}").order(step_count: :desc).first
  end
end

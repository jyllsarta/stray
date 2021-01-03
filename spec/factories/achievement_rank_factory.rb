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

FactoryBot.define do
  factory :achievement_rank, class: 'AchievementRank' do
    description { "すごい！" }
    rank { "SSS" }
    step_count { 5 }
  end
end

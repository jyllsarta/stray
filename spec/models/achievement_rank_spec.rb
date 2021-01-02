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

require 'rails_helper'

RSpec.describe AchievementRank, type: :model do
end

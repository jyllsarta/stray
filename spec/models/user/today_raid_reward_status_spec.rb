# == Schema Information
#
# Table name: user_today_raid_reward_statuses
#
#  id              :bigint           not null, primary key
#  day             :date
#  received_amount :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_user_today_raid_reward_statuses_on_user_id          (user_id)
#  index_user_today_raid_reward_statuses_on_user_id_and_day  (user_id,day) UNIQUE
#

require 'rails_helper'

RSpec.describe User::TodayRaidRewardStatus, type: :model do
end

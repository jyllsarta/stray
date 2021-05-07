# == Schema Information
#
# Table name: user_statuses
#
#  id                    :bigint           not null, primary key
#  coin                  :integer          default(0), not null
#  current_dungeon_depth :integer          default(1), not null
#  event_updated_at      :datetime
#  resurrect_timer       :integer          default(0), not null
#  returns_on_death      :boolean          default(FALSE), not null
#  star                  :integer          default(0), not null
#  velocity              :integer          default(100), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  current_dungeon_id    :integer          default(1), not null
#  user_id               :integer          not null
#

FactoryBot.define do
  factory :user_status, class: 'User::Status' do
    current_dungeon_depth { 1 }
    event_updated_at { Time.now }
    current_dungeon_id { 1 }
  end
end

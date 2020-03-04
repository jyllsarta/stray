# == Schema Information
#
# Table name: user_statuses
#
#  id                    :integer          not null, primary key
#  current_dungeon_depth :integer          default(1), not null
#  event_updated_at      :datetime         default(NULL), not null
#  resurrect_timer       :integer          default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  current_dungeon_id    :integer          default(1), not null
#  user_id               :integer          default(0), not null
#

require 'rails_helper'

RSpec.describe User::Status, type: :model do
end

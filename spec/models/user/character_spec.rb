# == Schema Information
#
# Table name: user_characters
#
#  id           :integer          not null, primary key
#  hp           :integer          default(0)
#  hp_max       :integer          default(0)
#  character_id :integer          default(NULL)
#  user_id      :integer          default(0)
#

require 'rails_helper'

RSpec.describe User::Character, type: :model do
end

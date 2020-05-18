# == Schema Information
#
# Table name: user_items
#
#  id      :integer          not null, primary key
#  rank    :integer          default(0)
#  item_id :integer          default(0)
#  user_id :integer          default(0)
#

require 'rails_helper'

RSpec.describe User::Relic, type: :model do
end

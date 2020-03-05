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

RSpec.describe User::Item, type: :model do
  describe "#parameter" do
    let(:user){ create(:user) }
    let!(:item){ create(:item, str: 100, dex: 100, def: 200, agi: 0) }
    let!(:user_item){ create(:user_item, user: user, item: item, rank: 5) }

    subject { user_item.parameter }
    it "returns character's parameter" do
      expect(subject).to eq({
                                str: 150, # 100 * 1.5
                                dex: 150, # 100 * 1.5
                                def: 300, # 200 * 1.5
                                agi: 0,   #   0 * 1.5
                            })
    end
  end
end

# == Schema Information
#
# Table name: user_dungeon_progresses
#
#  id         :integer          not null, primary key
#  max_depth  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dungeon_id :bigint           not null
#  user_id    :integer          default(0), not null
#
# Indexes
#
#  index_user_dungeon_progresses_on_dungeon_id  (dungeon_id)
#

require 'rails_helper'

RSpec.describe User::DungeonProgress, type: :model do
  describe "#dig_to!" do
    let(:user){ create(:user) }
    let(:dungeon) { create(:dungeon) }
    let(:status){ create(:user_status, user: user, dungeon: dungeon) }
    let!(:progress) { create(:user_dungeon_progress, user: user, dungeon: dungeon) }
    subject { progress.dig_to!(depth) }

    context "depth > progress" do
      let(:depth){ 10000 }
      it "updates max depth" do
        expect{ subject }.to change(progress, :max_depth).to(depth)
      end
    end

    context "depth > progress" do
      let(:depth){ 10000 }
      before do
        progress.update!(max_depth: depth + 1)
      end
      it "updates max depth" do
        expect{ subject }.to_not change(progress, :max_depth)
      end
    end
  end
end

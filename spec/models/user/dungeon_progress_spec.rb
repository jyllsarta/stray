# == Schema Information
#
# Table name: user_dungeon_progresses
#
#  id         :bigint           not null, primary key
#  cleared    :boolean          default(FALSE), not null
#  max_depth  :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  dungeon_id :bigint           not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_user_dungeon_progresses_on_dungeon_id              (dungeon_id)
#  index_user_dungeon_progresses_on_user_id_and_dungeon_id  (user_id,dungeon_id) UNIQUE
#

require 'rails_helper'

RSpec.describe User::DungeonProgress, type: :model do
  describe "#dig_to" do
    let(:user){ create(:user) }
    let(:dungeon) { create(:dungeon) }
    let(:status){ create(:user_status, user: user, dungeon: dungeon) }
    let!(:progress) { create(:user_dungeon_progress, user: user, dungeon: dungeon) }
    subject { progress.dig_to(depth) }

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
  describe "#clear!" do
    let(:user){ create(:user) }
    let(:dungeon) { create(:dungeon) }
    let!(:progress) { create(:user_dungeon_progress, user: user, dungeon: dungeon) }
    subject { progress.clear! }

    context "depth > progress" do
      let(:depth){ 10000 }
      it "updates max depth" do
        expect{ subject }.to change(progress, :cleared).to(true)
      end
    end
  end
end

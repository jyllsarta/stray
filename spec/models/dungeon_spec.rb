# == Schema Information
#
# Table name: dungeons
#
#  id         :integer          not null, primary key
#  depth      :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Dungeon, type: :model do
  describe "#rank" do
    let(:dungeon){ build(:dungeon) }
    subject { dungeon.rank(current_depth) }

    context "when current_depth < depth" do
      let(:current_depth) { 50 }
      it "returns depth_per_ranked num" do
        expect(subject).to eq( 50 / Constants.dungeon.depth_per_rank )
      end
    end

    context "when current_depth >>> depth" do
      let(:current_depth) { 1000000 }
      it "returns depth_per_ranked num" do
        expect(subject).to eq( dungeon.depth / Constants.dungeon.depth_per_rank )
      end
    end
  end
end

# == Schema Information
#
# Table name: enemies
#
#  id         :bigint           not null, primary key
#  hp         :integer          default(0)
#  name       :string(255)
#  rank       :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Enemy, type: :model do
  describe "#cards" do
    let(:enemy){ create(:enemy, :with_card) }
    subject { enemy.cards }

    it "returns cards" do
      expect(subject).to eq([
                                {:name=>"粘液", :power=>0, :tech=>0},
                                {:name=>"粘液", :power=>0, :tech=>0},
                                {:name=>"粘液", :power=>0, :tech=>0},
                                {:name=>"粘液", :power=>0, :tech=>0}
                            ])
    end
  end
end

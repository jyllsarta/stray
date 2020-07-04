# == Schema Information
#
# Table name: cards
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  power      :integer          default(0)
#  tech       :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "#to_card" do
    let(:card){ create(:card, name: "ぴよ", power: 7, tech: 2) }
    subject { card.to_card }

    it "returns parameter for card" do
      expect(subject).to eq({
                                name: "ぴよ",
                                power: 7,
                                tech: 2
                            })
    end
  end
end

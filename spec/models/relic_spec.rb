# == Schema Information
#
# Table name: relics
#
#  id              :bigint           not null, primary key
#  category        :integer          default(0)
#  cost            :integer          default(0)
#  description     :string(255)
#  name            :string(255)
#  rank            :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_relic_id :integer
#

require 'rails_helper'

RSpec.describe Relic, type: :model do
  describe "#obtain!" do
    let!(:dungeon){ create(:dungeon) }
    let(:user){ create(:user) }
    let!(:status){ create(:user_status, user: user) }
    subject { relic.obtain!(user) }

    context "succeeds" do
      let(:relic){ create(:relic) }

      before do
        user.status.update!(star: 10)
      end

      it "uses coin" do
        expect(user.status.star).to eq(10)
        subject
        expect(user.status.star).to eq(0)
      end
      it "gets" do
        expect{subject}.to change(user.relics, :count).by(1)
      end
    end

    context "insufficient star" do
      let(:relic){ create(:relic) }

      before do
        user.status.update!(star: 0)
      end

      it "raises" do
        expect{subject}.to raise_error Relic::InsufficientStar
      end
    end

    context "already had" do
      let(:relic){ create(:relic) }

      before do
        user.status.update!(star: 10)
        user.relics.create!(relic: relic)
      end

      it "raises" do
        expect{subject}.to raise_error Relic::AlreadyObtained
      end
    end

    context "has parent" do
      let(:parent_relic){ create(:relic) }
      let(:relic){ create(:relic, parent_relic_id: parent_relic.id) }

      before do
        user.status.update!(star: 10)
      end

      it "raises" do
        expect{subject}.to raise_error Relic::ParentNotObtained
      end

      context "has parent" do
        let!(:user_relic){create(:user_relic, user: user, relic: parent_relic)}
        it "gets" do
          expect{subject}.to change(user.relics, :count).by(1)
        end
      end
    end
  end
end

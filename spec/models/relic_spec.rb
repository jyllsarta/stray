# == Schema Information
#
# Table name: relics
#
#  id              :bigint           not null, primary key
#  category        :integer          default(NULL)
#  cost            :integer          default(0), not null
#  description     :string(255)
#  grid_x          :integer          default(0)
#  grid_y          :integer          default(0)
#  name            :string(255)
#  page            :integer          default(0)
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

      context "about associated skills" do
        context "if associated" do
          let!(:skill){ create(:skill) }
          let!(:relic_skill){ create(:relic_skill, relic: relic, skill: skill) }

          it "also gets skill" do
            expect{subject}.to change(user.skills, :count).by(1)
          end
        end

        context "if NOT associated" do
          let!(:skill){ create(:skill) }

          it "also gets skill" do
            expect{subject}.to_not change(user.skills, :count)
          end
        end
      end
    end

    context "insufficient star" do
      let(:relic){ create(:relic) }

      before do
        user.status.update!(star: 0)
      end

      it "raises" do
        expect{subject}.to raise_error User::Status::InsufficientStar
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

  describe "#rank_for!" do
    let!(:dungeon){ create(:dungeon) }
    let(:user){ create(:user) }
    let!(:status){ create(:user_status, user: user) }
    let(:relic){ create(:relic, category: :tirol_rank) }
    let!(:user_relic){ create(:user_relic, user: user, relic: relic)}
    subject { Relic.rank_for(user, category) }

    context "category tirol rank" do
      let(:category){ :tirol_rank }
      it "1" do
        expect(subject).to eq(1)
      end
    end

    context "has many" do
      let(:relic2){ create(:relic, category: :tirol_rank) }
      let(:relic3){ create(:relic, category: :tirol_rank) }
      let!(:user_relic2){ create(:user_relic, user: user, relic: relic2)}
      let!(:user_relic3){ create(:user_relic, user: user, relic: relic3)}
      let(:category){ :tirol_rank }
      it "3" do
        expect(subject).to eq(3)
      end
    end

    context "category another" do
      let(:category){ :event_time }
      it "0" do
        expect(subject).to eq(0)
      end
    end
  end
end

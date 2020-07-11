# == Schema Information
#
# Table name: skills
#
#  id               :bigint           not null, primary key
#  cost             :integer          default(0), not null
#  description      :string(255)
#  effect1_category :string(255)
#  effect1_to_self  :boolean
#  effect1_value    :integer
#  effect2_category :string(255)
#  effect2_to_self  :boolean
#  effect2_value    :integer
#  effect3_category :string(255)
#  effect3_to_self  :boolean
#  effect3_value    :integer
#  is_defence       :boolean          default(FALSE), not null
#  name             :string(255)      not null
#  reusable         :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Skill, type: :model do
  let(:user){ create(:user) }

  subject do
    skill.learn!(user)
  end

  describe "#learn!" do
    let(:skill){ create(:skill) }

    context "unlearned" do
      it "can get" do
        expect{subject}.to change(user.skills, :length).by(1)
      end
    end

    context "already learned" do
      before do
        user.skills.create!(skill: skill)
      end
      it "cannot get" do
        expect{subject}.to raise_error(Skill::AlreadyLearned)
      end
    end
  end
end
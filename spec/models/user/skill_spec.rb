# == Schema Information
#
# Table name: user_skills
#
#  id          :bigint           not null, primary key
#  is_equipped :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  skill_id    :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_user_skills_on_skill_id  (skill_id)
#  index_user_skills_on_user_id   (user_id)
#

require 'rails_helper'

RSpec.describe User::Skill, type: :model do
  describe "#equip_skill!" do
    let(:user) { create(:user) }
    let(:user_skills){ create_list(:user_skill, 6, :with_skill, user: user) }
    subject { User::Skill.equip_skill!(user, skill_ids) }

    context "正常系" do
      let(:skill_ids){ user_skills.map(&:skill_id).take(5) }
      it "装備を変更する" do
        subject
        expect(user.skills.find(user_skills.first.id).is_equipped).to eq(true)
      end
    end

    context "要求スキルIDが大盛り" do
      let(:skill_ids){ user_skills.map(&:skill_id) }
      it "エラー" do
        expect{subject}.to raise_error User::Skill::TooManySkill
      end
    end

    context "空振りスキルが混じってる" do
      let(:skill_ids){ user_skills.map(&:skill_id).take(4) + [-1] }
      it "エラーにはならないが、しれっと無視される" do
        subject
        expect(user.skills.equipped.length).to eq(4)
      end
    end
  end
end

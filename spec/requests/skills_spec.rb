require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Skill", type: :request do
  describe "GET /skills" do
    include_context("stub_current_user")
    let(:user){ create(:user) }
    let!(:skill){ create(:skill) }
    let!(:user_skill){ create(:user_skill, user: user, skill: skill) }
    let(:do_get) { get skills_path + ".json" }
    let(:params) do
      {}
    end
    subject do
      do_get
      response
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     skills: Array
                                                 }
                                             )
      end
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)&.[]('skills')&.first).to match_json_expression(
                                                                      {
                                                                          "id"=>Integer,
                                                                          "name"=>String,
                                                                          "description"=>nil,
                                                                          "reusable"=>Boolean,
                                                                          "is_defence"=>Boolean,
                                                                          "cost"=>Integer,
                                                                          "effect1_category"=>nil,
                                                                          "effect1_to_self"=>nil,
                                                                          "effect1_value"=>nil,
                                                                          "effect2_category"=>nil,
                                                                          "effect2_to_self"=>nil,
                                                                          "effect2_value"=>nil,
                                                                          "effect3_category"=>nil,
                                                                          "effect3_to_self"=>nil,
                                                                          "effect3_value"=>nil,
                                                                          "is_equipped"=>Boolean
                                                                      })
      end
    end
  end

  describe "POST /skills/equip" do
    include_context("stub_current_user")
    let(:user){ create(:user) }
    let!(:skill){ create(:skill) }
    let!(:user_skill){ create(:user_skill, user: user, skill: skill) }
    let(:do_post) { post equip_skills_path, params: params}
    let(:params) do
      {
          skill_ids: [user_skill.id]
      }
    end
    subject do
      do_post
      response
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     success: Boolean
                                                 }
                                             )
      end
    end
    context "bad request" do
      let(:params) do
        {
            skill_ids: [user_skill.id, 1, 1, 1, 1, 1, 1]
        }
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
  end
end
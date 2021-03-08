require 'rails_helper'

RSpec.describe "gacha", type: :request do
  include_context("stub_current_user")
  describe "GET /gacha" do
    let(:user){ User.create }
    let(:do_get) { get gacha_index_path + ".json" }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
        {
            gacha: {
                current_total_point: Integer,
                recent_fixed_rewards: Array,
                rates: Array,
                pot_grade: Integer,
                limit: Integer
            }  
        }
      )
    end
  end
  describe "POST /gacha" do
    let(:do_post) { post gacha_path + ".json", params: params }
    let(:user){ User.create }
    subject do
      do_post
      response
    end
    let(:params) do
      {
        amount: 100
      }
    end
    before do
      user.status.add_coin!(100)
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
        {
          rewards: {
            fixed_rewards: Array,
            random_rewards: Array,  
          }
        }
      )
    end
  end
end
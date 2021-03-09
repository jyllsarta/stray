require 'rails_helper'

RSpec.describe "gacha", type: :request do
  include_context("stub_current_user")
  describe "GET /gacha" do
    before do
      GachaFixedReward.delete_all
    end
    let(:user){ User.create }
    let(:do_get) { get gacha_index_path + ".json" }
    let!(:gacha_fixed_reward){ create(:gacha_fixed_reward, point: 100) }
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
                recent_fixed_rewards: [
                  {
                    id: gacha_fixed_reward.id
                  }.ignore_extra_keys!
                ],
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
require 'rails_helper'

RSpec.describe "gacha", type: :request do
  describe "GET /gacha" do
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
end
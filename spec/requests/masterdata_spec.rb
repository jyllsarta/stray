require 'rails_helper'

RSpec.describe "Masterdata", type: :request do
  describe "GET /masterdata" do
    let(:do_get) { get masterdata_path + ".json" }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   masterdata: {
                                                       items: Hash,
                                                       dungeons: Hash,
                                                   }
                                               }
                                           )
    end
  end
end
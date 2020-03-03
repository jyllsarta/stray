require 'rails_helper'

RSpec.describe "Clients", type: :request do
  describe "GET /clients" do
    let(:do_get) { get clients_path }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
    end
  end
end
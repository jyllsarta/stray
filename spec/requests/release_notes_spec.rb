require 'rails_helper'

RSpec.describe "ReleaseNotes", type: :request do
  describe "GET /release_notes" do
    let(:do_get) { get release_notes_path }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      # HTML なのでレスポンス形式はテストしない
    end
  end
end
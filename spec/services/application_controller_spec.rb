require 'rails_helper'

# グローバルなヘルパーのテスト
RSpec.describe ApplicationController, type: :model do
  let(:controller){ ApplicationController.new }
  describe "#current_user" do
    subject { controller.current_user }
    before do
      allow(controller).to receive(:render)
    end
    context "with no token" do
      before do
        allow(controller).to receive_message_chain(:request, :headers).and_return( {"X-AccessToken": ""} )
      end
      it "returns error response" do
        subject
        expect(controller).to have_received(:render).once # NoTokenのrescue
      end
    end
    context "with correct token" do
      let!(:user){ create(:user) }
      before do
        token = User::AccessToken.generate(user)
        allow(controller).to receive_message_chain(:request, :headers).and_return( {"X-AccessToken" => token} )
      end
      it "returns user object" do
        expect(subject).to eq(user)
        expect(controller).to_not have_received(:render) # NoTokenのrescue
      end
    end
    context "with invalid token" do
      let!(:user){ create(:user) }
      before do
        token = User::AccessToken.generate(user)
        allow(controller).to receive_message_chain(:request, :headers).and_return( {"X-AccessToken" => token + "something error string"} )
      end
      it "returns user object" do
        subject
        expect(controller).to have_received(:render).once # ActiveRecord::RecordNotFound の rescue
      end
    end
  end
end

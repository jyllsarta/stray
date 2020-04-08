require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "POST /users/create" do
    let(:do_post) { post users_path + ".json", params: params }
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end
    it 'returns events list' do
      expect(subject).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   access_token: String,
                                                   user_id: Integer
                                               }
                                           )
    end
  end

  describe "POST /users/:id/register_name" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_post) { post user_register_name_path(user_id: -1)+ ".json", params: params }
    let(:params) do
      {
          name: "1 taro",
          password: "secret password",
      }
    end
    subject do
      do_post
      response
    end
    context "name was unique" do
      before do
        allow(User).to receive(:same_name_user_exists?).and_return(false)
      end
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     success: Boolean
                                                 }
                                             )
      end
    end
    context "someone has duplicate names" do
      before do
        allow(User).to receive(:same_name_user_exists?).and_return(true)
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
    context "name missing" do
      let(:params) do
        {
            name: "",
            password: "secret password",
        }
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
    context "password missing" do
      let(:params) do
        {
            name: "1 taro",
            password: "",
        }
      end
      it 'fails' do
        expect(subject).to have_http_status(400)
      end
    end
  end

  describe "POST /users/:id/regenerate_token" do
    include_context("stub_current_user")
    let(:user){ create(:user) }
    let(:do_post) { post regenerate_token_users_path+ ".json", params: params }
    let(:params) do
      {
          name: user.name,
          password: "secret password",
      }
    end
    subject do
      do_post
      response
    end
    context "valid parameters" do
      before do
        user.register_name(name: user.name, password: "secret password")
      end
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     access_token: String,
                                                     user_id: Integer
                                                 }
                                             )
      end
    end
    context "username or password is wrong" do
      before do
        user.register_name(name: user.name, password: "altered secret password")
      end
      it 'fails' do
        expect(subject).to have_http_status(404)
      end
    end
  end

  describe "GET /users/:id/status" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let!(:item){ create(:item) }
    let!(:user_item){ create(:user_item, user: user, item: item)}
    let(:do_get) { get user_status_path(user_id: user.id) + ".json" }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   payload: {
                                                       user_id: Integer,
                                                       items: Hash,
                                                       dungeon_progresses: Hash,
                                                       status: {
                                                           current_dungeon_depth: Integer,
                                                           current_dungeon_id: Integer,
                                                           current_dungeon_rank: Integer
                                                       },
                                                       characters: {
                                                           spica: Hash,
                                                           tirol: Hash,
                                                       },
                                                       equips: {
                                                           spica: Array,
                                                           tirol: Array,
                                                       }
                                                   }
                                               }
                                           )
    end
  end

  describe "POST /users/:id/events" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_post) { post user_events_path(user_id: -1)+ ".json", params: params }
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end
    before do
      # イベントのフォーマットと内容のテストは別の場所でやる
      # ここで全種類のイベントが発生できるようにfactoryを書くのは地獄なのでやらない
      allow(EventFacade).to receive_message_chain(:new, :get_and_execute_latest_events!).and_return([])
    end
    it 'returns events list' do
      expect(subject).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   version: String,
                                                   events: Array,
                                                   next_event_at: Integer
                                               }
                                           )
    end
  end

  describe "POST /users/:id/resurrect" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_post) { post user_resurrect_path(user_id: -1)+ ".json", params: params }
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end
    it 'returns events list' do
      expect(subject).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   success: Boolean
                                               }
                                           )
    end
  end
end
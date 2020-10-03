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
                                                       relics: Hash,
                                                       dungeon_progresses: Hash,
                                                       quest_battle_parameters: {
                                                           hp: Integer,
                                                           power: Integer,
                                                           tech: Integer,
                                                           special: Integer
                                                       },
                                                       status: {
                                                           current_dungeon_depth: Integer,
                                                           current_dungeon_id: Integer,
                                                           current_dungeon_rank: Integer,
                                                           coin: Integer,
                                                           star: Integer,
                                                           velocity: Integer,
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

  describe "GET /users/:id/deck" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let(:do_get) { get user_deck_path(user_id: user.id) + ".json" }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   class_cards: Array,
                                                   item_cards: Array,
                                                   average_item_rank: Integer,
                                               }
                                           )
    end

    it 'deck is valid format' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)&.[]('item_cards')&.first).to match_json_expression(
                                               {
                                                   id: Integer,
                                                   name: String,
                                                   power: Integer,
                                                   tech: Integer,
                                               }
                                           )
    end
  end

  describe "GET /users/:id/won_enemies" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let!(:enemy){ create(:enemy) }
    let!(:won_enemy){ create(:user_won_enemy, user: user, enemy: enemy) }
    let(:do_get) { get user_won_enemies_path(user_id: user.id) + ".json" }
    subject do
      do_get
      response
    end
    it 'succeeds' do
      subject
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to match_json_expression(
                                               {
                                                   won_enemies: [
                                                       enemy_id: Integer
                                                   ],
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
                                                   next_event_at: Integer,
                                                   after_velocity: Integer,
                                               }
                                           )
    end

    context "about session id" do
      let(:do_post) { post user_events_path(user_id: -1)+ ".json", params: params, headers: headers }
      let(:headers) { {"X-SessionId": 123, "X-SessionStartedAt": 100} }
      context "succeeds" do
        before do
          SessionId.new(user).write(456, 50)
        end

        it "returns 200" do
          expect(subject).to have_http_status(200)
        end
      end

      context "fails" do
        before do
          SessionId.new(user).write(456, 200)
        end

        it "returns 200" do
          expect(subject).to have_http_status(400)
        end
      end
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

  describe "POST /users/:id/switch_dungeon" do
    include_context("stub_current_user")
    let(:dungeon){ create(:dungeon) }
    let(:user){ User.create }
    let(:do_post) { post user_switch_dungeon_path(user_id: -1)+ ".json", params: params }
    let(:params) do
      {
          dungeon_id: dungeon.id,
          depth: 1
      }
    end
    subject do
      do_post
      response
    end
    context "succeeds" do
      before do
        allow(user).to receive_message_chain(:status, :switch_dungeon!).and_return(true)
      end
      it 'returns nothing' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     success: true
                                                 }
                                             )
      end
    end
    context "fails" do
      before do
        allow(user).to receive_message_chain(:status, :switch_dungeon!).and_raise(User::Status::CannotSwitchDungeon)
      end
      it 'returns error' do
        expect(subject).to have_http_status(400)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     success: false,
                                                     message: String
                                                 }
                                             )
      end
    end
  end
end
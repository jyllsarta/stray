require 'rails_helper'
require 'json_expressions/rspec'

RSpec.describe "Enemies", type: :request do

  describe "GET /enemies/" do
    include_context("stub_current_user")
    let!(:enemy ) { create(:enemy) }
    let!(:dungeon){ create(:dungeon) }
    let!(:item){ create(:item, id: 1) unless Item.exists?(id: 1) }
    let!(:item2){ create(:item, id: 2) unless Item.exists?(id: 2) }
    let!(:user){ User.create }
    let(:do_get) { get enemies_path + ".json" }
    let(:params) do
      {
          enemy_id: enemy.id
      }
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
                                                     enemies: Array,
                                                 }
                                             )
      end
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)&.[]('enemies')&.first).to match_json_expression(
                                                 {
                                                     id: Integer,
                                                     name: String,
                                                     hp: Integer,
                                                     rank: Integer,
                                                     cards: Array,
                                                 }
                                             )
      end
    end
  end

  describe "POST /enemies/:id/engage" do
    include_context("stub_current_user")
    let!(:enemy ) { create(:enemy) }
    let(:user){ User.create }
    let(:do_post) { post enemy_engage_path(enemy_id: enemy.id)}
    let(:params) do
      {}
    end
    subject do
      do_post
      response
    end

    before do
      Rails.cache.delete("quest:#{user.id}")
    end
    context "succeeds" do
      it 'succeeds' do
        expect(subject).to have_http_status(200)
        expect(JSON.parse(response.body)).to match_json_expression(
                                                 {
                                                     playerHp: Integer,
                                                     enemyName: String,
                                                     enemyHp: Integer,
                                                     playerCards: Array,
                                                     enemyCards: Array,
                                                     seed: Integer,
                                                 }
                                             )
      end
    end
  end

  describe "POST /enemies/:id/showdown" do
    include_context("stub_current_user")
    let(:user){ User.create }
    let!(:enemy ) { create(:enemy) }
    let(:do_post) { post enemy_showdown_path(enemy_id: enemy.id), params: params }
    let(:params) do
      {
          operation_history: "[]"
      }
    end

    before do
      QuestBattle.new(user).engage!(enemy.id)
      allow_any_instance_of(QuestBattle).to receive(:showdown!).and_return({'isWin'=>true})
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
                                                     success: Boolean,
                                                     isWin: Boolean,
                                                 }
                                             )
      end
    end
  end
end
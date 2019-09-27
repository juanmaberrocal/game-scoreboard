require 'rails_helper'

RSpec.describe "V1/Matches", type: :request do
  describe "GET /matches" do
    it "works! (now write some real specs)" do
      get v1_matches_path, headers: auth_headers
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /matches" do
    let(:game) { create(:game) }
    let(:player) { create(:player) }

    let(:url) { v1_matches_path }
    let(:valid_params) do
      {
        game_id: game.id,
        results: {
          player.id.to_s => true
        }
      }
    end

    context 'valid' do
      context 'returns body' do
        it 'with new match id' do
          post url, params: { match: valid_params }.to_json, headers: auth_headers
          expect(json_id.present?).to eq(true)
        end

        it 'with associated game id' do
          post url, params: { match: valid_params }.to_json, headers: auth_headers
          expect(json_attribute('game_id')).to eq(game.id)
        end

        it 'with list of players' do
          post url, params: { match: valid_params }.to_json, headers: auth_headers
          expect(json_attribute('results')).to eq(valid_params[:results])
        end
      end

      include_examples("Create Request", :match)
    end

    context 'invalid' do
      context '`game_id` param' do
        context 'game does not exist' do
          it 'returns `internal_server_error`' do
            valid_params[:game_id] = 0
            post url, params: { match: valid_params }.to_json, headers: auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end

          include_examples("API Error")
        end

        include_examples("Bad Request", :post, :match, :game_id)
        include_examples("Bad Request", :post, :match, :game_id, 'foo')
      end

      context '`results` param' do
        context 'player does not exist' do
          it 'returns `internal_server_error`' do
            valid_params[:results] = { 0 => true }
            post url, params: { match: valid_params }.to_json, headers: auth_headers
            expect(response).to have_http_status(:unprocessable_entity)
          end

          include_examples("API Error")
        end

        include_examples("Bad Request", :post, :match, :results)
        include_examples("Bad Request", :post, :match, :results, [])
      end
    end
  end
end

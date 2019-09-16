require 'rails_helper'

RSpec.describe "Matches", type: :request do
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
        game_name: game.name,
        results: [
          { player.nickname => true }
        ]
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

      include_examples("Create Request", :post, :match, :game_name)
    end

    context 'invalid' do
      context '`game_name` param' do
        context 'game does not exist' do
          it 'returns `internal_server_error`' do
            valid_params[:game_name] = 'foo'
            post url, params: { match: valid_params }.to_json, headers: auth_headers
            expect(response).to have_http_status(:internal_server_error)
          end

          include_examples("API Error")
        end

        include_examples("Bad Request", :post, :match, :game_name)
        include_examples("Bad Request", :post, :match, :game_name, 1)
      end

      context '`results` param' do
        context 'player does not exist' do
          it 'returns `internal_server_error`' do
            valid_params[:results] = [{ 'foo' => true }]
            post url, params: { match: valid_params }.to_json, headers: auth_headers
            expect(response).to have_http_status(:internal_server_error)
          end

          include_examples("API Error")
        end

        include_examples("Bad Request", :post, :match, :results)
        include_examples("Bad Request", :post, :match, :results, {})
      end
    end
  end
end

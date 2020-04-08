# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1/Matches', type: :request do
  describe 'GET /matches' do
    subject { get url, headers: auth_headers }

    let(:matches) { create_list(:match, rand(1..5)) }
    let(:url) { v1_matches_path }

    before(:each) { subject }

    it 'works! (now write some real specs)' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /matches/1' do
    subject { get url, headers: auth_headers }

    let(:match) { create(:match) }
    let(:url) { v1_match_path(id: match.id) }

    before(:each) { subject }

    it 'works! (now write some real specs)' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /matches' do
    subject { post url, params: { match: valid_params }.to_json, headers: auth_headers }

    let(:game) { create(:game) }
    let(:player) { create(:player) }
    let(:results) { { player.id.to_s => true } }

    let(:url) { v1_matches_path }
    let(:valid_params) do
      {
        game_id: game.id,
        results: results
      }
    end

    context 'valid' do
      context 'returns body' do
        before(:each) { subject }

        it 'with new match id' do
          expect(json_id.present?).to eq(true)
        end

        it 'with associated game' do
          expect(json_relationship('game')['id']).to eq(game.id.to_s)
        end

        it 'with associated match_players' do
          expect(json_relationship('match_players').length).to eq(results.keys.length)
        end

        it 'with list of results' do
          expect(json_attribute('results')).to eq(valid_params[:results])
        end
      end

      it_behaves_like('Create Request', :match)
    end

    context 'invalid' do
      context '`game_id` param' do
        context 'game does not exist' do
          let(:valid_params) { { game_id: 0, results: results } }

          before(:each) { subject }

          it 'returns `internal_server_error`' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it_behaves_like('API Error')
        end

        it_behaves_like('Bad Request', :post, :match, :game_id)
        it_behaves_like('Bad Request', :post, :match, :game_id, 'foo')
      end

      context '`results` param' do
        context 'player does not exist' do
          let(:results) { { '0' => true } }

          before(:each) { subject }

          it 'returns `internal_server_error`' do
            expect(response).to have_http_status(:unprocessable_entity)
          end

          it_behaves_like('API Error')
        end

        it_behaves_like('Bad Request', :post, :match, :results)
        it_behaves_like('Bad Request', :post, :match, :results, [])
      end
    end
  end
end

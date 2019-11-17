# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /renew' do
    let(:player) { create(:player) }

    context 'with valid authorization header' do
      before(:each) { get renew_player_session_path, headers: auth_headers(player) }
      include_examples 'Valid JWT Token'

      it 'returns player' do
        expect(json_id).to eq(player.id)
      end
    end
  end

  describe 'POST /login' do
    let(:player) { create(:player) }
    let(:params) do
      {
        player: {
          email: player.email,
          password: player.password
        }
      }
    end

    context 'with correct params' do
      before(:each) { post player_session_path, params: params }
      include_examples 'Valid JWT Token'

      it 'returns player' do
        expect(json_id).to eq(player.id)
      end
    end

    context 'with incorrect params' do
      it 'returns 401 with wrong email' do
        params[:player][:email] = 'foo'

        post player_session_path, params: params
        expect(response).to have_http_status(401)
      end

      it 'returns 401 with wrong password' do
        params[:player][:password] = 'foo'

        post player_session_path, params: params
        expect(response).to have_http_status(401)
      end

      it 'returns 401 with wrong structure' do
        foo_params = params[:player]

        post player_session_path, params: foo_params
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /logout' do
    it 'returns 204, no content' do
      delete destroy_player_session_path
      expect(response).to have_http_status(204)
    end
  end
end

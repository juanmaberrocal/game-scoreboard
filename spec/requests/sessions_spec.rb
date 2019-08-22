require 'rails_helper'

RSpec.shared_examples "Valid JWT Token" do
  it 'returns 200' do
    expect(response).to have_http_status(200)
  end

  it 'returns JWT token in header' do
    expect(response.headers['Authorization']).to be_present
  end

  it 'returns valid JWT token' do
    token_from_request = response.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token_from_request, ENV['DEVISE_JWT_SECRET_KEY'], true)
    expect(decoded_token.first['sub']).to be_present
  end
end

RSpec.describe "Sessions", type: :request do
  let(:player) { create(:player) }
  let(:params) do
    {
      player: {
        email: player.email,
        password: player.password
      }
    }
  end

  describe "GET /renew" do
    context 'with valid authorization header' do
      before(:each) { get player_session_renew_path, headers: auth_headers }
      include_examples "Valid JWT Token"
    end
  end

  describe "POST /login" do
    context 'with correct params' do
      before(:each) { post player_session_path, params: params }
      include_examples "Valid JWT Token"
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

  describe "DELETE /logout" do
    it 'returns 204, no content' do
      delete destroy_player_session_path
      expect(response).to have_http_status(204)
    end
  end
end

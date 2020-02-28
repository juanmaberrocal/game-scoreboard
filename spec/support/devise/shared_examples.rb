# frozen_string_literal: true

module Devise::SharedExamples
  # JWT
  RSpec.shared_examples 'Valid JWT Token' do
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
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'System', type: :request do
  describe 'GET /ping' do
    subject { get ping_path }

    before(:each) { subject }

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns \'pong\'' do
      expect(response.body).to eq('pong')
    end
  end
end

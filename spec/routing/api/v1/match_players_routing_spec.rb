# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MatchPlayersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/matches/1/match_players').to route_to('api/v1/match_players#index', match_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/v1/match_players/1').to route_to('api/v1/match_players#show', id: '1')
    end

    it 'routes to #confirm' do
      expect(post: '/v1/match_players/1/confirm').to route_to('api/v1/match_players#confirm', id: '1')
    end

    it 'routes to #reject' do
      expect(post: '/v1/match_players/1/reject').to route_to('api/v1/match_players#reject', id: '1')
    end
  end
end

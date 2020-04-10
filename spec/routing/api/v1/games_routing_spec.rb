# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GamesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/games').to route_to('api/v1/games#index')
    end

    it 'routes to #show' do
      expect(get: '/v1/games/1').to route_to('api/v1/games#show', id: '1')
    end

    it 'routes to #statistics' do
      expect(get: '/v1/games/1/statistics').to route_to('api/v1/games#statistics', id: '1')
    end

    it 'routes to #standings' do
      expect(get: '/v1/games/1/standings').to route_to('api/v1/games#standings', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/games').to route_to('api/v1/games#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/games/1').to route_to('api/v1/games#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/games/1').to route_to('api/v1/games#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/v1/games/1').to route_to('api/v1/games#destroy', id: '1')
    end

    it 'routes to matches#index' do
      expect(get: '/v1/games/1/matches').to route_to('api/v1/matches#index', game_id: '1')
    end

    it 'routes to matches#show' do
      expect(get: '/v1/games/1/matches/1').to route_to('api/v1/matches#show', game_id: '1', id: '1')
    end
  end
end

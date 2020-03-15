require 'rails_helper'

RSpec.describe Api::V1::SlackBotController, type: :routing do
  describe 'routing' do
    it 'routes to #game_score' do
      expect(post: '/v1/slack_bot/game_score').to route_to('api/v1/slack_bot#game_score')
    end

    it 'routes to #game_scoreboard' do
      expect(post: '/v1/slack_bot/game_scoreboard').to route_to('api/v1/slack_bot#game_scoreboard')
    end

    it 'routes to #match_score' do
      expect(post: '/v1/slack_bot/match_score').to route_to('api/v1/slack_bot#match_score')
    end

    it 'routes to #player_score' do
      expect(post: '/v1/slack_bot/player_score').to route_to('api/v1/slack_bot#player_score')
    end

    it 'routes to #player_scoreboard' do
      expect(post: '/v1/slack_bot/player_scoreboard').to route_to('api/v1/slack_bot#player_scoreboard')
    end
  end
end

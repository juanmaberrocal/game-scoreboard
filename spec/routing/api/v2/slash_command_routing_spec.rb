# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V2::SlashCommandController, type: :routing do
  describe 'routing' do
    it 'routes to #game_scoreboard' do
      expect(post: '/v2/slash_command/game_scoreboard').to route_to('api/v2/slash_command#game_scoreboard')
    end
  end
end

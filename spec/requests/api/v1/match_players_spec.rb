require 'rails_helper'

RSpec.describe "MatchPlayers", type: :request do
  describe "GET /match_players" do
    it "works! (now write some real specs)" do
      get v1_match_players_path, headers: auth_headers
      expect(response).to have_http_status(200)
    end
  end
end

require 'rails_helper'

RSpec.describe "V1/Games", type: :request do
  describe "GET /games" do
    it "works! (now write some real specs)" do
      get v1_games_path, headers: auth_headers
      expect(response).to have_http_status(200)
    end
  end
end

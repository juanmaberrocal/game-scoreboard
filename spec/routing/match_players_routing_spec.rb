require "rails_helper"

RSpec.describe Api::V1::MatchPlayersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/match_players").to route_to("match_players#index")
    end

    it "routes to #show" do
      expect(:get => "/match_players/1").to route_to("match_players#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/match_players").to route_to("match_players#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/match_players/1").to route_to("match_players#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/match_players/1").to route_to("match_players#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/match_players/1").to route_to("match_players#destroy", :id => "1")
    end
  end
end

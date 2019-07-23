require "rails_helper"

RSpec.describe Api::V1::GamesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/v1/games").to route_to("api/v1/games#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/games/1").to route_to("api/v1/games#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/v1/games").to route_to("api/v1/games#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/v1/games/1").to route_to("api/v1/games#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/v1/games/1").to route_to("api/v1/games#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/v1/games/1").to route_to("api/v1/games#destroy", :id => "1")
    end
  end
end

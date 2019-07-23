require "rails_helper"

RSpec.describe Api::V1::MatchesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/v1/matches").to route_to("api/v1/matches#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/matches/1").to route_to("api/v1/matches#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/v1/matches").to route_to("api/v1/matches#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/v1/matches/1").to route_to("api/v1/matches#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/v1/matches/1").to route_to("api/v1/matches#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/v1/matches/1").to route_to("api/v1/matches#destroy", :id => "1")
    end
  end
end

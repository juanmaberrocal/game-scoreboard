require "rails_helper"

RSpec.describe Api::V1::PlayersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/v1/players").to route_to("api/v1/players#index")
    end

    it "routes to #show" do
      expect(:get => "/v1/players/1").to route_to("api/v1/players#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/v1/players").to route_to("api/v1/players#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/v1/players/1").to route_to("api/v1/players#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/v1/players/1").to route_to("api/v1/players#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/v1/players/1").to route_to("api/v1/players#destroy", :id => "1")
    end
  end
end

require 'rails_helper'

RSpec.describe "V1/Players", type: :request do
  describe "GET /players" do
    let(:players) { create_list(:player, 5) }
    
    let(:url) { v1_players_path }
    let(:valid_params) { {} }

    it 'returns list of players' do
      get url, headers: auth_headers
      expect(json_data.length).to eq(1) # current player
    end
    
    include_examples("Get Request")
  end

  describe "GET /player/:id/standings" do
    let(:player) { create(:player_with_matches) }
    
    let(:url) { standings_v1_player_path(id: player.id) }
    let(:valid_params) { {} }

    context 'valid' do
      context 'returns body' do
        it 'with player id' do
          get url, headers: auth_headers
          expect(json_id).to eq(player.id)
        end

        it 'with standings list' do
          get url, headers: auth_headers
          expect(json_attribute('standings')).to eq(player.standings)
        end
      end

      include_examples("Get Request")
    end

    context 'invalid' do
      context '`id` param' do
        let(:url) { standings_v1_player_path(id: 0) }
        let(:valid_params) { {} }

        include_examples("Not Found", :get)
      end
    end
  end

  describe "PUT /players" do
    let(:player) { create(:player) }
    
    let(:url) { v1_player_path(id: player.id) }
    let(:valid_params) { { first_name: 'foo' } }
    let(:auth_header_override) { auth_headers(player) }

    context 'valid' do
      context 'permitted params' do
        {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          email: Faker::Internet.unique.email,
          nickname: Faker::FunnyName.unique.name,
          # avatar: Faker::Avatar.image('image.jpg')
        }.each do |attribute, value|
          it "returns updated `#{attribute}` as `#{value}`" do
            put url, params: { player: { attribute => value } }.to_json, headers: auth_headers(player)

            player.reload
            expect(json_attribute(attribute)).to eq(value)
          end
        end
      end

      context 'unpermitted params' do
        {
          password: Faker::Internet.unique.password,
          birth_date: Faker::Date.birthday,
        }.each do |attribute, value|
          it "does not return updated `#{attribute}` as `#{value}`" do
            put url, params: { player: { attribute => value } }.to_json, headers: auth_headers(player)

            player.reload
            expect(json_attribute(attribute)).to_not eq(value)
          end
        end
      end

      it 'returns updated player' do
        put url, params: { player: valid_params }.to_json, headers: auth_headers(player)
        expect(json_id).to eq(player.id)
      end

      context 'as admin' do
        let(:admin_player) { create(:player, role: :admin) }

        it 'can update any player' do
          put url, params: { player: valid_params }.to_json, headers: auth_headers(admin_player)
          expect(json_id).to eq(player.id)
        end
      end

      include_examples("Update Request", :player)
    end
    
    context 'invalid' do
      context '`id` param' do
        context 'for player that doesn\'t exist' do
          let(:url) { v1_player_path(id: 0) }
          let(:valid_params) { {} }
          include_examples("Not Found", :put)
        end

        context 'for a different player than current' do
          let(:foo_player) { create(:player) }
          let(:url) { v1_player_path(id: foo_player.id) }
          let(:valid_params) { {} }
          include_examples("Forbidden", :put)
        end
      end

      context '`player` param key' do
        let(:url) { v1_player_path(id: player.id) }
        let(:valid_params) { {} }
        include_examples("Bad Request", :put)
      end
    end
  end
end

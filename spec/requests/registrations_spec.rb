# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Registrations', type: :request do
  describe 'POST /signup' do
    let(:password) { Faker::Internet.password }
    let(:params) do
      {
        player: {
          email: Faker::Internet.unique.email,
          password: password,
          password_confirmation: password,
          nickname: Faker::FunnyName.unique.name,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name
        }
      }
    end

    context 'with correct params' do
      before(:each) { post player_registration_path, params: params }
      include_examples 'Valid JWT Token'

      it 'returns player' do
        expect(json_id).to_not be_blank
      end
    end

    context 'with incorrect params' do
      it 'returns 422 with invalid email' do
        params[:player][:email] = 'foo'

        post player_registration_path, params: params
        expect(response).to have_http_status(422)
      end

      it 'returns 422 with invalid password' do
        params[:player][:password] = 'foo'
        params[:player][:password_confirmation] = 'foo'

        post player_registration_path, params: params
        expect(response).to have_http_status(422)
      end

      it 'returns 422 with invalid password_confirmation' do
        params[:player][:password_confirmation] = 'foo'

        post player_registration_path, params: params
        expect(response).to have_http_status(422)
      end

      %i[
        email
        password
        password_confirmation
        nickname
        first_name
        last_name
      ].each do |param|
        it "returns 400 when `#{param}` not passed" do
          params[:player].delete(param)

          post player_registration_path, params: params
          expect(response).to have_http_status(400)
        end
      end

      it 'returns 400 with wrong structure' do
        foo_params = params[:player]

        post player_registration_path, params: foo_params
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'POST /update_password' do
    let(:player) { create(:player) }
    let(:password) { Faker::Internet.password }
    let(:params) do
      {
        player: {
          current_password: player.password,
          password: password,
          password_confirmation: password
        }
      }
    end
    let(:post_url) do
      post update_password_player_registration_path,
           params: params.to_json,
           headers: auth_headers(player)
    end

    context 'with correct params' do
      before(:each) { post_url }
      include_examples 'Valid JWT Token'

      it 'returns player' do
        expect(json_id).to eq(player.id)
      end
    end

    context 'with incorrect params' do
      it 'returns 422 with invalid email' do
        params[:player][:current_password] = 'foo'

        post_url
        expect(response).to have_http_status(422)
      end

      it 'returns 422 with invalid password' do
        params[:player][:password] = 'foo'

        post_url
        expect(response).to have_http_status(422)
      end

      it 'returns 422 with invalid password_confirmation' do
        params[:player][:password_confirmation] = 'foo'

        post_url
        expect(response).to have_http_status(422)
      end
    end
  end
end

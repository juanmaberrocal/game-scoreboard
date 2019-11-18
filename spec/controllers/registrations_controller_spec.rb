# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  # Every time you want to unit test a devise controller,
  # you need to tell Devise which mapping to use.
  # We need that because ActionController::TestCase and spec/controllers
  # bypass the router and it is the router that tells Devise
  # which resource is currently being accessed,
  # you can do that with:
  before(:each) { request.env['devise.mapping'] = Devise.mappings[:player] }

  describe 'POST #create' do
    let(:password) { Faker::Internet.password }
    let(:valid_create_params) do
      attributes_for(:player).merge(password: password,
                                    password_confirmation: password)
    end

    context 'with valid params' do
      it 'creates a new Player' do
        expect do
          post :create, params: { player: valid_create_params }
        end.to change(Player, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:invalid_create_params) do
        attrs = valid_create_params
        attrs.delete(:email)
        attrs
      end

      it 'does not creates a new Player' do
        expect do
          post :create, params: { player: invalid_create_params }
        end.to_not change(Player, :count)
      end
    end
  end

  describe 'POST #update_password' do
    let(:player) { create(:player) }
    let(:password) { Faker::Internet.password }
    let(:valid_update_password_params) do
      {
        current_password: 'foo',
        password: password,
        password_confirmation: password
      }
    end

    # This should return the minimal set of values that should be in the session
    # in order to pass any filters (e.g. authentication) defined in
    # RegistrationsController. Be sure to keep this updated too.
    before(:each) { request.headers.merge!(auth_headers(player)) }

    context 'with valid params' do 
      xit 'updates player password' do
        expect do
          post :update_password, params: { player: valid_update_password_params }
        end.to change(player, :password).from(player.password).to(password)
      end
    end

    context 'with invalid params' do
      let(:invalid_update_password_params) do
        attrs = valid_update_password_params
        attrs.delete(:password_confirmation)
        attrs
      end

      it 'does not creates a new Player' do
        expect do
          post :update_password, params: { player: invalid_update_password_params }
        end.to_not change(player, :password)
      end
    end
  end
end

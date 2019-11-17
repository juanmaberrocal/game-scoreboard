# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/signup').to route_to('registrations#create')
    end

    it 'routes to #update_password' do
      expect(post: '/update_password').to route_to('registrations#update_password')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SystemController, type: :routing do
  describe 'routing' do
    it 'routes to #ping' do
      expect(get: '/ping').to route_to('system#ping')
    end
  end
end

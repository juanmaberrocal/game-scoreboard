# frozen_string_literal: true

require_relative 'api/shared_examples'
require_relative 'devise/shared_examples'
require_relative 'models/shared_examples'

RSpec.configure do |config|
  config.include Api::SharedExamples, type: :request
  config.include Devise::SharedExamples, type: :request

  config.include Models::SharedExamples, type: :model
end

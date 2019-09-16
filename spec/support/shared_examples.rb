require_relative 'api/shared_examples'

RSpec.configure do |config|
  config.include Api::SharedExamples, type: :request
end

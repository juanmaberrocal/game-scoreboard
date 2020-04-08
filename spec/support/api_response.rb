# frozen_string_literal: true

module ApiResponse
  def json_body
    JSON.parse(response.body)
  end

  def json_data
    json_body['data']
  end

  def json_id
    json_data['id'].to_i
  end

  def json_attributes
    json_data['attributes']
  end

  def json_attribute(attribute)
    json_attributes[attribute.to_s]
  end

  def json_relationships
    json_data['relationships']
  end

  def json_relationship(relationship)
    json_relationships[relationship.to_s]['data']
  end

  def json_included
    json_body['included']
  end
end

RSpec.configure do |config|
  config.include ApiResponse, type: :request
end

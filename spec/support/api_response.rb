module ApiResponse
  def json_body
    JSON.parse(response.body)
  end

  def json_data
    json_body['data']
  end

  def json_id
    json_data['id']
  end

  def json_attributes
    json_data['attributes']
  end

  def json_attribute(attribute)
    json_attributes[attribute.to_s]
  end
end

RSpec.configure do |config|
  config.include ApiResponse, type: :request
end

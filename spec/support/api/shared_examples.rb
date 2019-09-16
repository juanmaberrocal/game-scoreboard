module Api::SharedExamples
  # Base API
  RSpec.shared_examples "API Response" do
    it 'returns `application/json`' do
      expect(response.content_type).to eq('application/json')
    end
  end

  # Valid API
  RSpec.shared_examples "Create Request" do |request, param_key|
    before(:each) do
      params = if param_key.present?
                 { param_key => valid_params }
               else 
                valid_params
               end

      send(request, url, params: params.to_json, headers: auth_headers)
    end

    it "returns created" do
      expect(response).to have_http_status(:created)
    end

    include_examples("API Response")
  end

  # Invalid API
  RSpec.shared_examples "API Error" do
    it 'returns `error` key' do
      expect(JSON.parse(response.body).key?('error')).to eq(true)
    end

    include_examples("API Response")
  end

  RSpec.shared_examples "Bad Request" do |request, param_key, invalid_param, invalid_param_value|
    before(:each) do
      if invalid_param_value.present?
        valid_params[invalid_param] = invalid_param_value
      else 
        valid_params.delete(invalid_param)
      end

      params = if param_key.present?
                 { param_key => valid_params }
               else 
                valid_params
               end

      send(request, url, params: params.to_json, headers: auth_headers)
    end

    it "returns bad_request if not provided" do
      expect(response).to have_http_status(:bad_request)
    end

    include_examples("API Error")
  end
end

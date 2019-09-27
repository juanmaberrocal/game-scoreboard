module Api::SharedExamples
  # Base API
  RSpec.shared_examples "API Response" do
    it 'returns `application/json`' do
      expect(response.content_type).to eq('application/json')
    end
  end

  # Valid API
  RSpec.shared_examples "Get Request" do |param_key|
    context 'get request' do
      before(:each) do
        params = if param_key.present?
                   { param_key => valid_params }
                 else 
                  valid_params
                 end

        send(:get, url, params: params.to_json, headers: (headers || auth_headers))
      end

      it "returns `ok`" do
        expect(response).to have_http_status(:ok)
      end

      include_examples("API Response")
    end
  end

  RSpec.shared_examples "Create Request" do |param_key|
    context 'create request' do
      before(:each) do
        params = if param_key.present?
                   { param_key => valid_params }
                 else 
                  valid_params
                 end

        send(:post, url, params: params.to_json, headers: (headers || auth_headers))
      end

      it "returns `created`" do
        expect(response).to have_http_status(:created)
      end

      include_examples("API Response")
    end
  end

  RSpec.shared_examples "Update Request" do |param_key|
    context 'update request' do
      before(:each) do
        params = if param_key.present?
                   { param_key => valid_params }
                 else 
                  valid_params
                 end

        send(:put, url, params: params.to_json, headers: (headers || auth_headers))
      end

      it "returns `ok`" do
        expect(response).to have_http_status(:ok)
      end

      include_examples("API Response")
    end
  end

  # Invalid API
  RSpec.shared_examples "API Error" do
    it 'returns `error` key' do
      expect(JSON.parse(response.body).key?('error')).to eq(true)
    end

    include_examples("API Response")
  end

  RSpec.shared_examples "Not Found" do |request, param_key|
    before(:each) do
      params = if param_key.present?
                 { param_key => valid_params }
               else 
                valid_params
               end

      send(request, url, params: params.to_json, headers: (headers || auth_headers))
    end

    it "returns not_found if no record found" do
      expect(response).to have_http_status(:not_found)
    end

    include_examples("API Error")
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

      send(request, url, params: params.to_json, headers: (headers || auth_headers))
    end

    it "returns bad_request if not provided" do
      expect(response).to have_http_status(:bad_request)
    end

    include_examples("API Error")
  end

  # Slackbot API
  RSpec.shared_examples "Slack API Response" do
    before(:each) do
      post v2_slash_command_game_scoreboard_path, params: params, headers: (headers || auth_headers)
    end

    it 'returns `response_type` as `ephemeral`' do
      expect(json_body['response_type']).to eq(response_type)
    end

    it "returns ok" do
      expect(response).to have_http_status(:ok)
    end

    it 'returns `application/json`' do
      expect(response.content_type).to eq('application/json')
    end
  end
end

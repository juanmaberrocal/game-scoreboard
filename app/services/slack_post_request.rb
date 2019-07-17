require 'net/http'

class SlackPostRequest
  attr_reader :response_url, :user_id

  def initialize(response_url, user_id = nil)
    @response_url = response_url
    @user_id      = user_id
  end


  def post(body)
    request_body(body)
    
    http.use_ssl = true
    http.request(request)
  end

  private

  CONTENT_TYPE = 'application/json'.freeze

  def uri
    @uri ||= URI.parse(response_url)
  end

  def http
    @http ||= Net::HTTP.new(uri.host, uri.port)
  end

  def request
    @request ||= Net::HTTP::Post.new(uri.path, { 'Content-Type' => CONTENT_TYPE })
  end

  def request_body(body)
    body = request_context(body) if user_id.present?
    request.body = body.to_json
  end

  def request_context(body)
    body[:blocks] << {
      type: 'context',
      elements: [
        {
          type: 'mrkdwn',
          text: "Requested by: <#{user_id}>"
        }
      ]
    }
  end
end

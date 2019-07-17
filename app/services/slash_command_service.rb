class SlashCommandService
  attr_reader :text, :blocks,
              :response_url, :user_id

  def initialize
    @text   = ''
    @blocks = []
  end

  def fetch_response
    build_response
  end


  def post_response(response_url, user_id = nil)
    @response_url = response_url
    @user_id      = user_id

    build_body

    http.use_ssl = true
    http.request(request)
  end

  private

  CONTENT_TYPE = 'application/json'.freeze
  
  def build_response; end

  def uri
    @uri ||= URI.parse(response_url)
  end

  def http
    @http ||= Net::HTTP.new(uri.host, uri.port)
  end

  def request
    @request ||= Net::HTTP::Post.new(uri.path, { 'Content-Type' => CONTENT_TYPE })
  end

  def build_body
    body = {}

    add_text
    add_blocks

    request.body = body.to_json
  end

  def add_text
  end

  def add_blocks
  end
end

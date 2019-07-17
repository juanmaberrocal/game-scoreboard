class SlashCommandService
  attr_reader :blocks

  def initialize
    @blocks = []
  end

  def fetch_response
    build_response
  end


  def post_response(response_url, user_id = nil)
    SlackPostRequest.new(response_url, user_id)
                    .post(build_body)
  end

  private
  
  def build_response; end

  def build_body
    {}.tap do |body|
      body[:blocks] = blocks     if blocks.present?
      body[:blocks] = error_text unless blocks.present?
    end
  end

  def error_text
    [
      {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: 'No data could be collected for your request, sorry!'
        }
      }
    ]
  end
end

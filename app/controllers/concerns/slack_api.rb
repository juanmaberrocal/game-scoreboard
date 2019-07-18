module SlackApi
  extend ActiveSupport::Concern

  private

  DEFAULT_RESPONSE_TYPE = 'ephemeral'.freeze
  DEFAULT_SUCCESS_TEXT  = 'Sounds good, processing request. Please wait a minute.'.freeze
  DEFAULT_ERROR_TEXT    = 'Sorry, that didn\'t work. Please try again.'.freeze

  def success_response(text = self.class::DEFAULT_SUCCESS_TEXT,
                       response_type = self.class::DEFAULT_RESPONSE_TYPE,
                       attachments = [])
    slack_response(text, response_type, attachments)
  end

  def error_response(text = self.class::DEFAULT_ERROR_TEXT,
                     response_type = self.class::DEFAULT_RESPONSE_TYPE,
                     attachments = [])
    slack_response(text, response_type, attachments)
  end

  def slack_response(text, response_type, attachments)
    json_response = { response_type: response_type, text: text }
    json_response[:attachments] = attachments if attachments.present?

    render json: json_response, status: 200
  end

  def slack_signature
    headers['X-Slack-Signature']
  end

  def slack_timestamp
    headers['X-Slack-Request-Timestamp']
  end

  def slack_body
    body
  end

  def slack_command
    params[:command]
  end

  def slack_action
    params[:text]
  end

  protected

  # Authenticate the slash command with signature based authentication
  def authenticate
    SlackRequestAuthenticator.new(slack_signature, slack_timestamp, slack_body)
                             .authenticate!
  rescue InvalidSlackRequest => e
    error_response(e.message)
  rescue => e
    error_response
  end

  def validate
    SlashCommandValidator.new(slack_command, slack_action)
                         .validate!
  rescue InvalidSlashCommand => e
    error_response(e.message)
  rescue => e
    error_response
  end
end

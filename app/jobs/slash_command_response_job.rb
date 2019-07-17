class SlashCommandResponseJob < ApplicationJob
  queue_as :default

  def perform(command, response_url, user_id, *args)
    slash_command_service = SlashCommandServicePicker.new(command)
                                                     .select(*args)

    slash_command_service.fetch_response
    slash_command_service.post_response(response_url, user_id)
  rescue InvalidSlashCommand => e
    SlackPostRequest.new(response_url, user_id)
                    .post(slack_error_message(e.message))
  rescue => e
    SlackPostRequest.new(response_url, user_id)
                    .post(slack_error_message)
  end

  private

  DEFAULT_ERROR_MESSAGE = 'Sorry, that didn\'t work. Please try again.'.freeze

  def slack_error_message(message = DEFAULT_ERROR_MESSAGE)
    {
      blocks: [
        { section:
          {
            type: 'text',
            text: {
              type: 'mrkdwn',
              text: message
            }
          }
        }
      ]
    }
  end
end

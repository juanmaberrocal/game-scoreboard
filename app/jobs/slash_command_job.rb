class SlashCommandJob < ApplicationJob
  queue_as :default

  def perform(response_url, user_id, *args)
    perform_slash_command(response_url, user_id, *args)
  rescue InvalidSlashCommand => e
    slack_post_error(response_url, user_id, e.message)
  rescue => e
    slack_post_error(response_url, user_id)
  end

  private

  DEFAULT_ERROR_MESSAGE = 'Sorry, that didn\'t work. Please try again.'.freeze

  def perform_slash_command(response_url, user_id, *args); end

  def slack_post_error(response_url, user_id, message = DEFAULT_ERROR_MESSAGE)
    SlackPostRequest.new(response_url, user_id)
                    .post(slack_error_message(message))
  end

  def slack_error_message(message)
    {
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: message
          }
        }
      ]
    }
  end
end

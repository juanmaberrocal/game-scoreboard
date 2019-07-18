class SlashCommandActionJob < SlashCommandJob
  private

  def perform_slash_command(response_url, user_id, action)
    action, model, params = SlashCommandActionParser.new(action)
                                                    .parse

    slash_command_action_service = SlashCommandActionServicePicker.new(action, model)
                                                                  .select(params)

    slash_command_action_service.fetch_response
    slash_command_action_service.post_response(response_url, user_id)
  end
end

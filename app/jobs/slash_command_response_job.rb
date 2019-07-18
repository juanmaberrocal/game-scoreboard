class SlashCommandResponseJob < SlashCommandJob
  private

  def perform_slash_command(response_url, user_id, command, *args)
    slash_command_service = SlashCommandServicePicker.new(command)
                                                     .select(*args)

    slash_command_service.fetch_response
    slash_command_service.post_response(response_url, user_id)
  end
end

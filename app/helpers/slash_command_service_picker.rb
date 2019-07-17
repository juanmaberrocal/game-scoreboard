class SlashCommandServicePicker
  def select(command, *args)
    case command
    when 'game-score'
      SlashCommands::GameScoreService.new(*args)
    else
      InvalidSlashCommand.new(command)
    end
  end
end

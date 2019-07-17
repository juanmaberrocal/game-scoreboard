class SlashCommandServicePicker
  attr_reader :command

  def initialize(command)
    @command = command
  end

  def select(*args)
    case command
    when 'game-score'
      SlashCommands::GameScoreService.new(*args)
    else
      InvalidSlashCommand.new(command)
    end
  end
end

class SlashCommandServicePicker
  attr_reader :command

  def initialize(command)
    @command = command
  end

  def select(*args)
    case command
    when '/game-score'
      SlashCommands::GameScoreService.new(*args)
    when '/games-score'
      SlashCommands::GamesScoreService.new(*args)
    when '/match-score'
      SlashCommands::MatchScoreService.new(*args)
    when '/player-score'
      SlashCommands::PlayerScoreService.new(*args)
    when '/players-score'
      SlashCommands::PlayersScoreService.new(*args)
    else
      raise InvalidSlashCommand.new(command)
    end
  end
end

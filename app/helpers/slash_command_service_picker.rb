class SlashCommandServicePicker
  attr_reader :command

  def initialize(command)
    @command = command
  end

  def select(*args)
    case command
    when '/game-score'
      SlashCommands::GameStandingsService.new(*args)
    when '/games-score'
      SlashCommands::GamesStandingsService.new(*args)
    when '/match-score'
      SlashCommands::MatchStandingsService.new(*args)
    when '/player-score'
      SlashCommands::PlayerStandingsService.new(*args)
    when '/players-score'
      SlashCommands::PlayersStandingsService.new(*args)
    else
      raise InvalidSlashCommand.new(command)
    end
  end
end

class InvalidGameRequest < StandardError
  attr_reader :game

  def initialize(game)
    @game = game
    super()
  end

  def message
    "Sorry, `#{game.titleize}` was not found. "\
    "Here are several games you can look for: "\
    "#{message_games.pluck(:name).map { |g| "`#{g}`" }.join(', ')}"
  end

  private

  def message_games
    games = similar_games
    games = random_games if games.blank?
    games
  end

  def similar_games
    Game.find_by_similar_name(game)
        .sample(3)
  end

  def random_games
    Game.random(3)
  end
end

class InvalidGameRequest < StandardError
  attr_reader :game

  def initialize(game)
    @game = game
    super()
  end

  def message
    "Sorry, #{game.titleize} was not found. "\
    "Here are several games you can look for: "\
    "#{Game.pluck(:name).sample(3).map { |g| "`#{g}`" }.join(', ') }"\
  end
end

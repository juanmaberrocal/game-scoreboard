module SlashCommands
  class GameStandingsService < StandingsService
    attr_reader :game

    def initialize(game_id)
      self.game = game_id
      super()
    end

    def fetch_response
      fetch_standings
      super()
    end

    private

    def game=(g)
      @game = Game.find_by(id: g)
    end

    def fetch_standings
      @standings = game.present? ? game.standings : []
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "The current champion of `#{game.name}` is *#{standings.first[:name]}*. "\
                "Here are the complete standings:"
        }
      }
    end

    def no_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "No games of `#{game.name}` have been played yet!"
        }
      }
    end
  end
end

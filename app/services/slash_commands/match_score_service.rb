module SlashCommands
  class MatchScoreService < StandingsService
    attr_reader :game, :match

    def initialize(game_id)
      self.game = game_id
      super()
    end

    def fetch_response
      fetch_match
      fetch_standings
      super()
    end

    private

    def game=(g)
      @game = Game.find_by(id: g)
    end

    def fetch_match
      @match = game.present? ? game.last_match : nil
    end

    def fetch_standings
      @standings = match.present? ? match.standings : []
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "The last game of `#{game.name}` was played on #{match.played_on}. "\
                "Here are the results:"
        }
      }
    end

    def yes_response_block_text(standing)
      "*#{standing[:position]}.* "\
      "#{standing[:name]} "\
      "#{standing[:num_won].zero? ? '' : '_(Winner)_'} "
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

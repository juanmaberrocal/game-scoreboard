module SlashCommands
  class GameScoreService < SlashCommandService
    attr_reader :game,
                :match, :standings

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

    def build_response
      if match.present?
        yes_match_response
      else
        no_match_response
      end
    end

    def yes_match_response
      yes_match_text
      yes_match_blocks
    end

    def yes_match_text
      @text = "The last game of `#{game.name}` was played on #{match.played_on}. "\
              "Here are the results:"
    end

    def yes_match_blocks
      standings.each do |standing|
        yes_match_block(standing)
      end
    end

    def yes_match_block(standing)
      @blocks << {
        type: 'section',
        text: yes_match_block_text(standing)
      }
    end

    def yes_match_block_text(standing)
      "*#{standing[:position]}. "\
      "#{standing[:winner] ? '(_Winner_)' : ''}* "\
      "#{standing[:player].capitalize}"
    end

    def no_match_response
      no_match_text
    end

    def no_match_text
      @text = "No games of `#{game.name}` have been played yet!"
    end
  end
end

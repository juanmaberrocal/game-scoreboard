module SlashCommands
  class GameScoreService < SlashCommandService
    attr_reader :game,
                :match, :players

    def initialize(game_id)
      game = game_id
      super()
    end

    def fetch_response
      fetch_match
      fetch_players
      super()
    end

    private

    def game=(g)
      @game = Game.find_by(id: g)
    end

    def fetch_match
      @match = game.present? ? Match.where(game_id: game.id).last : nil
    end

    def fetch_players
      @players = match.present? ? match.players.pluck(:nickname) : []
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
      @text = "The last game of `#{game.name}` was played on #{game.created_at.strftime('%m/%d/%Y')}. "\
              "Here are the results:"
    end

    def yes_match_blocks
      players.each_with_index do |player, i|
        yes_match_block(player, i + 1)
      end
    end

    def yes_match_block(player, position)
      @blocks << {
        type: 'section',
        text: "*#{position}.* #{player.capitalize}"
      }
    end

    def no_match_response
      no_match_text
    end

    def no_match_text
      @text = "No games of `#{game.name}` have been played yet!"
    end
  end
end

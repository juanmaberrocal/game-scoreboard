module SlashCommandActions
  class GameViewService < ViewService
    private

    def record=(game_name)
      @record = Game.find_by_name(game_name)
    end

    def fetch_standings
      @standings = record.present? ? record.standings : []
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "The current champion of `#{record.name}` is *#{standings.first[:name]}*. "\
                "Here are the complete standings:"
        }
      }
    end

    def no_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "No games of `#{record.name}` have been played yet!"
        }
      }
    end

    def help_response_block_text
      "No game found! You can try some of the following: "\
      "#{Game.random(3).map { |g| "`#{g.name}`" }.join(', ')}"
    end
  end
end

module SlashCommandActions
  class MatchViewService < ViewService
    attr_reader :match

    def initialize(game_name)
      super
      fetch_match
    end

    private

    def record=(game_name)
      @record = Game.find_by_name(id: game_name)
    end

    def fetch_match
      @match = record.present? ? record.last_match : nil
    end

    def fetch_standings
      @standings = match.present? ? match.standings : []
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "The last game of `#{record.name}` was played on #{match.played_on}. "\
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

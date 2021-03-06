module SlashCommands
  class PlayersStandingsService < StandingsService

    def fetch_response
      fetch_standings
      super()
    end

    private

    def fetch_standings
      @standings = Player.standings
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "The boardgames champion is *#{standings.first[:name]}*. "\
                "Here are the complete standings:"
        }
      }
    end

    def no_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "No one has played any games yet!"
        }
      }
    end
  end
end

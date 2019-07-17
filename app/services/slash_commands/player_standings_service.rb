module SlashCommands
  class PlayerStandingsService < StandingsService
    attr_reader :player

    def initialize(player_id)
      self.player = player_id
      super()
    end

    def fetch_response
      fetch_standings
      super()
    end

    private

    def player=(pl)
      @player = Player.find_by(id: pl)
    end

    def fetch_standings
      @standings = player.present? ? player.standings : []
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "`#{player.player_name}'s` best game is *#{standings.first[:name]}*. "\
                "Here are the complete standings:"
        }
      }
    end

    def no_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "`#{player.name}` has not played any games yet!"
        }
      }
    end
  end
end

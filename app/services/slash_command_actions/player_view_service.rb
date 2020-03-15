module SlashCommandActions
  class PlayerViewService < ViewService
    private

    def record=(player_name)
      @record = Player.find_by_name(player_name)
    end

    def fetch_standings
      @standings = record.present? ? record.standings : []
    end

    def yes_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "`#{record.player_name}'s` best game is *#{standings.first[:name]}*. "\
                "Here are the complete standings:"
        }
      }
    end

    def no_response_text
      @blocks << {
        type: 'section',
        text: {
          type: 'mrkdwn',
          text: "`#{record.name}` has not played any games yet!"
        }
      }
    end

    def help_response_block_text
      "No player found! You can try some of the following: "\
      "#{Player.random(3).map { |pl| "`#{pl.nickname}`" }.join(', ')}"
    end
  end
end

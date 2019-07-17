module StandingsGenerators
  class PlayersStandingsService < StandingsGeneratorService
    def initialize
      super(Player, nil)
    end

    def generate
      data_array = build_data_array
      super(data_array)
    end

    private

    def matches_won
      @matches_won ||= MatchPlayer.select(:player_id)
                                  .where(winner: true)
    end

    def select_player(player_id)
      player_list.select { |pl| pl.id == player_id }.first
    end

    def build_data_array
      {}.tap do |games_won|
        matches_won.each do |match_won|
          games_won[match_won.player_id] ||= EMPTY_DATA_ENTRY.dup

          games_won[match_won.player_id][:name]     = select_player(match_won.player_id).player_name
          games_won[match_won.player_id][:num_won] += 1
        end
      end.map { |player_id, player_data| { name: player_data[:name], num_won: player_data[:num_won] } }
    end
  end
end

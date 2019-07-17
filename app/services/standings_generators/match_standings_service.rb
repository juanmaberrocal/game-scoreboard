module StandingsGenerators
  class MatchStandingsService < StandingsGeneratorService
    def initialize(record)
      super(Match, record)
    end

    def generate
      data_array = build_data_array
      super(data_array)
    end

    private

    def match_players
      @match_players ||= record.match_players
                               .select(:id, :player_id, :winner)
    end

    def select_player(player_id)
      player_list.select { |pl| pl.id == player_id }.first
    end

    def build_data_array
      {}.tap do |games_won|
        match_players.each do |match_player|
          games_won[match_player.player_id] ||= EMPTY_DATA_ENTRY.dup

          games_won[match_player.player_id][:name]     = select_player(match_player.player_id).player_name
          games_won[match_player.player_id][:num_won] += 1 if match_player.winner
        end
      end.map { |player_id, player_data| { name: player_data[:name], num_won: player_data[:num_won] } }
    end
  end
end

module StandingsGenerators
  class GameStandingsService < StandingsGeneratorService
    def initialize(record)
      super(Game, record)
    end

    def generate
      data_array = build_data_array
      super(data_array)
    end

    private

    def match_winners
      @match_winners ||= MatchPlayer.select(:id, :player_id)
                                    .where(match_id: record.matches.pluck(:id), winner: true)
    end

    def select_player(player_id)
      player_list.select { |pl| pl.id == player_id }.first
    end

    def build_data_array
      {}.tap do |games_won|
        match_winners.each do |match_winner|
          games_won[match_winner.player_id] ||= EMPTY_DATA_ENTRY.dup

          games_won[match_winner.player_id][:name]     = select_player(match_winner.player_id).player_name
          games_won[match_winner.player_id][:num_won] += 1
        end
      end.map { |player_id, player_data| { name: player_data[:name], num_won: player_data[:num_won] } }
    end
  end
end

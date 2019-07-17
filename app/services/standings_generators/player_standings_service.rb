module StandingsGenerators
  class PlayerStandingsService < StandingsGeneratorService
    def initialize(record)
      super(Player, record)
    end

    def generate
      data_array = build_data_array
      super(data_array)
    end

    private

    def matches_won
      @matches_won ||= record.matches.select(:id, :game_id).where(match_players: { winner: true })
    end

    def select_game(game_id)
      game_list.select { |g| g.id == game_id }.first
    end

    def build_data_array
      {}.tap do |games_won|
        matches_won.each do |match_won|
          games_won[match_won.game_id] ||= EMPTY_DATA_ENTRY.dup

          games_won[match_won.game_id][:name]     = select_game(match_won.game_id).name
          games_won[match_won.game_id][:num_won] += 1
        end
      end.map { |game_id, game_data| { name: game_data[:name], num_won: game_data[:num_won] } }
    end
  end
end

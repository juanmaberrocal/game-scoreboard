class MatchSerializer < FastJsonapiSerializer
  attributes :game_id, :played_on

  belongs_to :game

  attribute :winner, if: Proc.new { |_match, params|
    params[:game_id].present? || params[:player_id].present?
  } do |match, _params|
    match.winner
  end

  attribute :results, if: Proc.new { |_match, params|
    params[:with_results].present?
  } do |match, _params|
    {}.tap do |results_hash|
      match.match_players.each do |match_player|
        results_hash[match_player.player_id] = match_player.winner
      end
    end
  end
end

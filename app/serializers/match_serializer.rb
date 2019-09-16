class MatchSerializer < FastJsonapiSerializer
  attributes :game_id

  belongs_to :game

  attribute :winner, if: Proc.new { |match, params|
    params[:game_id].present? || params[:player_id].present?
  } do |match, _params|
    match.winner
  end

  attribute :results, if: Proc.new { |match, params|
    params[:with_results].present?
  } do |match, _params|
    match.match_players.includes(:player).map do |match_player|
      {
        match_player.player_name => match_player.winner
      }
    end
  end
end

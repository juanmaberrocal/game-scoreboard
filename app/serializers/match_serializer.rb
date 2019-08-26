class MatchSerializer < FastJsonapiSerializer
  attributes :game_id

  belongs_to :game

  attribute :winner, if: Proc.new { |match, params|
    params[:player_id].present?
  } do |match, params|
    match.winner
  end
end

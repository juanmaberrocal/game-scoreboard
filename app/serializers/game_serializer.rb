class GameSerializer < FastJsonapiSerializer
  attributes :name

  attributes :description,
             :min_players,
             :max_players,
             :min_play_time,
             :max_play_time, if: Proc.new { |player, params|
    params[:public]&.to_bool.blank?
  }
end

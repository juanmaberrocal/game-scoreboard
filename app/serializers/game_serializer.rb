class GameSerializer < FastJsonapiSerializer
  attributes :name,
             :description,
             :min_players,
             :max_players,
             :min_play_time,
             :max_play_time
end

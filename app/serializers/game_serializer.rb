class GameSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name,
             :description,
             :min_players,
             :max_players,
             :min_play_time,
             :max_play_time
end

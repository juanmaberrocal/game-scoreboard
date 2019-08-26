class MatchPlayerSerializer < FastJsonapiSerializer
  attributes :match_id,
             :player_id,
             :winner

  belongs_to :match
end

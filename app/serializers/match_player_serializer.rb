# frozen_string_literal: true

class MatchPlayerSerializer < FastJsonapiSerializer
  belongs_to :match, links: {
    self: ->(match_player) { "/matches/#{match_player.match_id}" }
  }

  belongs_to :player, links: {
    self: ->(match_player) { "/players/#{match_player.player_id}" }
  }

  attributes :result_status, :winner
end

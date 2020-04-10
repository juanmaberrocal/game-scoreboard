# frozen_string_literal: true

class MatchSerializer < FastJsonapiSerializer
  belongs_to :game, links: {
    self: ->(match) { "/games/#{match.game_id}" }
  }

  has_many :match_players, links: {
    related: ->(match) { "/matches/#{match.id}/match_players" }
  }

  attributes :match_status, :played_on

  attribute :results, if: proc { |_match, params|
    params[:with_results].present?
  } do |match, _params|
    {}.tap do |results_hash|
      match.match_players.each do |match_player|
        results_hash[match_player.player_id] = match_player.winner
      end
    end
  end
end

class Player < ApplicationRecord
  has_many :match_players
  has_many :matches, -> { order 'matches.created_at DESC' }, through: :match_players

  def last_match
    matches.first
  end
end

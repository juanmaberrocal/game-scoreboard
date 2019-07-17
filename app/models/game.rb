class Game < ApplicationRecord
  has_many :matches, -> { order 'matches.created_at DESC' }

  def last_match
    matches.first
  end
end

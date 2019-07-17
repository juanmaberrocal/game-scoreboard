# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  birth_date :date
#  first_name :string
#  last_name  :string
#  nickname   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ApplicationRecord
  has_many :match_players
  has_many :matches, -> { order 'matches.created_at DESC' }, through: :match_players

  def self.standings
    StandingsGenerators::PlayersStandingsService.new
                                                .generate
  end

  def player_name(full_name = false)
    if full_name
      full_name
    else
      nickname
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_match
    matches.first
  end

  def standings
    StandingsGenerators::PlayerStandingsService.new(self)
                                               .generate
  end
end

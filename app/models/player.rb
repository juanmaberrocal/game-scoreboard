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
  has_many :match_players, inverse_of: :player
  has_many :matches, -> { order 'matches.created_at DESC' }, through: :match_players

  validates :first_name, :last_name, :nickname, presence: true
  validates :nickname, uniqueness: { case_sensitive: false }

  def self.find_by_name(search_name)
    Player.find_by(nickname: search_name) ||
    Player.similar('first_name || last_name', search_name).sample
  end

  def self.standings
    StandingsGenerators::PlayersStandingsService.new
                                                .generate
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def player_name(use_full_name = false)
    if use_full_name
      full_name
    else
      nickname
    end
  end

  def last_match
    matches.first
  end

  def standings
    StandingsGenerators::PlayerStandingsService.new(self)
                                               .generate
  end
end

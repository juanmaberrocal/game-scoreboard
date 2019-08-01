# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  birth_date :date
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string           not null
#  nickname   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_players_on_email                     (email) UNIQUE
#  index_players_on_first_name_and_last_name  (first_name,last_name)
#  index_players_on_nickname                  (nickname) UNIQUE
#

class Player < ApplicationRecord
  has_many :match_players, inverse_of: :player
  has_many :matches, -> { order 'matches.created_at DESC' }, through: :match_players

  validates :first_name, :last_name, :nickname, :email, presence: true
  validates :nickname, :email, uniqueness: { case_sensitive: false }

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

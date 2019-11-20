# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id                     :bigint           not null, primary key
#  birth_date             :date
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
#  nickname               :string           not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("player"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_players_on_email                     (email) UNIQUE
#  index_players_on_first_name_and_last_name  (first_name,last_name)
#  index_players_on_nickname                  (nickname) UNIQUE
#  index_players_on_reset_password_token      (reset_password_token) UNIQUE
#

# Players are users. Each player has an email and password for logging in
# and accessing the information available.
# Players can have different roles,
# which controls the amount of data they can manage
# Players play multiple Match records;
# they have their match results stored against MatchPlayer records
class Player < ApplicationRecord
  # Include default devise modules:
  #   :recoverable, :rememberable
  # Others available are:
  #   :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist

  has_one_attached :avatar

  has_many :match_players, inverse_of: :player
  has_many :matches, -> { order 'matches.created_at DESC' },
           through: :match_players

  validates :first_name, :last_name, :nickname, :email, presence: true
  validates :nickname, :email, uniqueness: { case_sensitive: false }

  enum role: %i[admin player]

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

  def statistics
    StatisticsGenerators::PlayerStatisticsService.new(self)
                                                 .generate
  end

  def standings
    StandingsGenerators::PlayerStandingsService.new(self)
                                               .generate
  end
end

# == Schema Information
#
# Table name: matches
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_matches_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#

class Match < ApplicationRecord
  belongs_to :game

  has_many :match_players, -> { order 'match_players.winner DESC' }, dependent: :destroy
  has_many :players, through: :match_players

  def played_on(format = '%m/%d/%Y')
    created_at.strftime(format)
  end

  def match_winners
    match_players.includes(:player)
                 .where(winner: true)
  end

  def standings
    StandingsGenerators::MatchStandingsService.new(self)
                                              .generate
  end
end

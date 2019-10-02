# == Schema Information
#
# Table name: matches
#
#  id           :bigint           not null, primary key
#  match_status :integer          default("pending"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  game_id      :bigint           not null
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

  has_many :match_players, -> { order 'match_players.winner DESC' }, inverse_of: :match, dependent: :destroy
  has_many :players, through: :match_players

  validates_associated :game

  enum match_status: [:pending, :confirmed, :rejected]

  # game_id: int
  # results:
  # {
  #   player_id: winner[1|0],
  #   player_id: winner[1|0],
  #   ...
  # }
  def self.initialize_with_results(game_id, results = {})
    match = Match.new(game_id: game_id)

    results.each do |player_id, winner|
      match.match_players.build(player_id: player_id, winner: winner)
    end

    match
  end

  def self.create_with_results(game_name, results = [])
    match = initialize_with_results(game_name, results)
    match.save! if match.present?
    match
  end

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

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

  has_many :match_players, -> { order 'match_players.winner DESC' }, inverse_of: :match, dependent: :destroy
  has_many :players, through: :match_players

  # results:
  # [
  #   { player_name: winner[1|0] },
  #   { player_name: winner[1|0] }
  #   ...
  # ]
  def self.initialize_with_results(game_name, results = [])
    game = Game.find_by_name(game_name)
    return nil unless game.present?

    match = Match.new(game: game)

    results.each do |result|
      player_name, winner = result.flatten.map(&:to_s)

      player = Player.find_by_name(player_name)
      return unless player.present?

      match.match_players.build(player: player, winner: winner.to_bool)
    end

    if match.match_players.size == results.size
      match
    else
      nil
    end
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

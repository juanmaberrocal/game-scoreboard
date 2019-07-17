class Match < ApplicationRecord
  belongs_to :game

  has_many :match_players, -> { order 'match_players.winner' }
  has_many :players, through: :match_players

  def played_on(format = '%m/%d/%Y')
    created_at.strftime(format)
  end

  def standings
    [].tap do |standing|
      match_players.includes(:player).each_with_index do |match_player, i|
        standing << {
          position: (i + 1),
          player:   match_player.player.nickname,
          winner:   match_player.winner
        }
      end
    end
  end
end

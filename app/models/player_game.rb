# frozen_string_literal: true

# == Schema Information
#
# Table name: player_games
#
#  id         :bigint           not null, primary key
#  favorite   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  player_id  :bigint           not null
#
# Indexes
#
#  index_player_games_on_game_id                (game_id)
#  index_player_games_on_player_id              (player_id)
#  index_player_games_on_player_id_and_game_id  (player_id,game_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (player_id => players.id)
#

class PlayerGame < ApplicationRecord
  belongs_to :player
  belongs_to :game

  validates :game, uniqueness: { scope: :player }
  validates_associated :player, :game, on: :create
end

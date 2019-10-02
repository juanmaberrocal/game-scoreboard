# == Schema Information
#
# Table name: match_players
#
#  id            :bigint           not null, primary key
#  result_status :integer          default("pending"), not null
#  winner        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  match_id      :bigint           not null
#  player_id     :bigint           not null
#
# Indexes
#
#  index_match_players_on_match_id   (match_id)
#  index_match_players_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (player_id => players.id)
#

class MatchPlayer < ApplicationRecord
  belongs_to :match
  belongs_to :player

  validates_associated :match, :player

  enum result_status: [:pending, :confirmed, :rejected]

  def player_name(full_name = false)
    player.player_name(full_name)
  end
end

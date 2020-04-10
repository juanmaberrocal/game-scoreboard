# frozen_string_literal: true

# == Schema Information
#
# Table name: match_players
#
#  id            :bigint           not null, primary key
#  result_status :enum             default("pending"), not null
#  winner        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  match_id      :bigint           not null
#  player_id     :bigint           not null
#
# Indexes
#
#  index_match_players_on_match_id       (match_id)
#  index_match_players_on_player_id      (player_id)
#  index_match_players_on_result_status  (result_status)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (player_id => players.id)
#

# MatchPlayers are records of an individual players result for a given Match.
# The records keep track of who played what game
# and which of those players won the match
class MatchPlayer < ApplicationRecord
  include WithStatus

  belongs_to :match
  belongs_to :player

  validates_associated :match, :player, on: :create

  after_update :trigger_match_status_change,
               if: :saved_change_to_result_status?

  def player_name(full_name = false)
    player.player_name(full_name)
  end

  private

  def trigger_match_status_change
    match.trigger_status_change
  end
end

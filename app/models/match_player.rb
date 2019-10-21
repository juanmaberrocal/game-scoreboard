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
  RESULT_STATUSES = %i[pending confirmed rejected].freeze

  belongs_to :match
  belongs_to :player

  validates_associated :match, :player

  validates_each :result_status, on: :update, if: :result_status_changed? do |record, attr, value|
    old_status = record.result_status_was.to_sym
    new_status = record.result_status.to_sym

    case new_status
    when :confirmed, :rejected
      record.errors.add(attr, "Status cannot be updated from `#{old_status}` to `#{new_status}`") unless old_status == :pending
    else
      record.errors.add(attr, "Status cannot be updated to `#{new_status}`")
    end
  end

  enum result_status: RESULT_STATUSES

  RESULT_STATUSES.each do |scope_status|
    scope scope_status, -> { where(result_status: scope_status) }
  end

  def player_name(full_name = false)
    player.player_name(full_name)
  end
end

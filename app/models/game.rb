# == Schema Information
#
# Table name: games
#
#  id            :bigint           not null, primary key
#  description   :text
#  max_play_time :integer
#  max_players   :integer
#  min_play_time :integer
#  min_players   :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Game < ApplicationRecord
  has_many :matches, -> { order 'matches.created_at DESC' }

  def last_match
    matches.first
  end
end

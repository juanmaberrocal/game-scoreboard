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
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Game < ApplicationRecord
  has_many :matches, -> { order 'matches.created_at DESC' }

  before_save :slug_name, if: :will_save_change_to_name?

  def self.find_by_name(search_name)
    Game.find_by(slug: search_name.parameterize)
  end

  def self.find_by_similar_name(search_name)
    Game.similar(:slug, search_name.downcase)
  end

  def self.standings
    StandingsGenerators::GamesStandingsService.new
                                              .generate
  end

  def random_match
    matches.sample(1).first
  end

  def last_match
    matches.first
  end

  def standings
    StandingsGenerators::GameStandingsService.new(self)
                                             .generate
  end

  private

  def slug_name
    self.slug_name = self.name.parameterize
  end
end

# frozen_string_literal: true

module StatisticsGenerators
  class GameStatisticsService
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def generate
      raw_statistics.each do |raw_statistic|
        statistics[:leaderboard] << {
          player_id: raw_statistic.player_id,
          played:    raw_statistic.played,
          won:       raw_statistic.won
        }
      end

      percentiles
      statistics
    end

    private

    PERCENTILES = [
      90,
      75,
      50
    ].freeze

    def statistics
      @statistics ||= {
        leaderboard: [],
        percentiles: {}
      }
    end

    def raw_statistics
      @raw_statistics ||= Match.joins(:match_players)
                               .select(['match_players.player_id',
                                        'COUNT(matches.id) AS "played"',
                                        'SUM(CAST(match_players.winner AS INT)) AS "won"'])
                               .where(game: @record)
                               .group(:player_id)
                               .order(won: :desc, played: :asc)
    end

    def percentiles
      PERCENTILES.each do |pct|
        statistics[:percentiles][pct] = percentile(pct)
      end
    end

    # description: calculate nth percentile
    # i = (p / 100) * n
    # v = (i + (i + 1)) / 2
    # rubocop:disable AbcSize
    def percentile(pct)
      n = raw_statistics.length
      i = ((pct.to_f / 100) * n).ceil

      x = raw_statistics[n - (i - 0)]&.won || 0
      y = raw_statistics[n - (i - 1)]&.won || 0

      ((x + y).to_f / 2).ceil
    end
    # rubocop:enable AbcSize
  end
end

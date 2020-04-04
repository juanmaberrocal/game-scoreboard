# frozen_string_literal: true

module StatisticsGenerators
  class PlayerStatisticsService
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def generate
      raw_statistics.each do |raw_statistic|
        statistics[:breakdown][raw_statistic.game_id] = {
          played: raw_statistic.played,
          won:    raw_statistic.won
        }
        statistics[:total_played] += raw_statistic.played
        statistics[:total_won]    += raw_statistic.won
      end

      statistics
    end

    private

    def statistics
      @statistics ||= {
        breakdown: {},
        total_won: 0,
        total_played: 0
      }
    end

    def raw_statistics
      Match.joins(:match_players)
           .select(['matches.game_id',
                    'COUNT(match_players.id) AS "played"',
                    'SUM(CAST(match_players.winner AS INT)) AS "won"'])
           .where(match_players: { player: @record })
           .confirmed
           .group(:game_id)
           .order(won: :desc, played: :asc)
    end
  end
end

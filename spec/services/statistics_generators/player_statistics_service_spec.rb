# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatisticsGenerators::PlayerStatisticsService, type: :service do
  let(:service) { StatisticsGenerators::PlayerStatisticsService.new(record) }
  let(:record) { create(:player) }

  context '#initialize' do
    it 'sets the `@record` attribute' do
      expect(service.record).to eq(record)
    end
  end

  context '#generate' do
    context 'returns a `Hash`' do
      it { expect(service.generate.is_a?(Hash)).to eq(true) }

      context 'with keys' do
        %i[breakdown total_played total_won].each do |key|
          it "`#{key}`" do
            expect(service.generate.key?(key)).to eq(true)
          end
        end
      end
    end

    context '#raw_statistics' do
      let(:record) { create(:player_with_matches) }

      it 'returns matches of `@record` only' do
        create_list(:match_player, 5)
        expect(service.send(:raw_statistics).length).to eq(record.match_players.length)
      end

      context 'returns attribute' do
        %w[game_id played won].each do |attribute|
          it "`#{attribute}`" do
            raw_statistics = service.send(:raw_statistics)
            expect(raw_statistics[0].attributes.key?(attribute)).to eq(true)
          end
        end
      end
    end
  end
end

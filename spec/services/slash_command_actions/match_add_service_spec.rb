require 'rails_helper'

RSpec.describe SlashCommandActions::MatchAddService, type: :service do
  let(:service) { SlashCommandActions::MatchAddService.new(record_params_string) }
  let(:blocks) { [] }
  let(:klass) { Match }
  let(:record_params_string) do
    "game:#{game.name.gsub(':', '')}\n"\
    "#{winner.nickname}:true\n"\
    "#{loser.nickname}:false"
  end
  let(:record_params) do
    {
      game: game.name.gsub(':', ''),
      "#{winner.nickname}": 'true',
      "#{loser.nickname}": 'false'
    }
  end

  let(:game) { create(:game) }
  let(:winner) { create(:player) }
  let(:loser) { create(:player) }

  context '#initialize' do
    it 'sets the `@block` attribute' do
      expect(service.blocks).to eq(blocks)
    end

    it 'sets the @klass` attribute' do
      expect(service.klass).to eq(klass)
    end

    it 'sets the @record_params` attribute' do
      expect(service.record_params).to eq(record_params)
    end
  end

  context '#build_record' do
    it 'returns valid `Match` record' do
      record = service.send(:build_record)
      expect(record.valid?).to eq(true)
    end

    it 'returns `Match` for specified game' do
      record = service.send(:build_record)
      expect(record.game).to eq(game)
    end

    it 'returns `MatchPlayer`s for specified results' do
      record = service.send(:build_record)
      match_results = record.match_players.map { |match_player| [match_player.player_id, match_player.winner] }
      expect(match_results).to eq([[winner.id, true], [loser.id, false]])
    end
  end
end

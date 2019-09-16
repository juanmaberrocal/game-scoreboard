require 'rails_helper'

RSpec.describe Match, type: :model do
  let(:foo_match) { create(:match) }

  context 'relations' do
    it { is_expected.to belong_to(:game) }
    it { is_expected.to have_many(:players) }
    it { is_expected.to have_many(:match_players) }
  end

  context '#_with_results' do
    let(:foo_game) { create(:game) }
    let(:foo_players) { create_list(:player, 2) }
    let(:foo_results) do
      {}.tap do |results_hash|
        foo_players.each do |foo_player|
          results_hash[foo_player.id] = false
        end
      end
    end

    context '#initialize_with_results' do
      it 'returns valid match record' do
        expect(Match.initialize_with_results(foo_game.id, foo_results).valid).to eq(true)
      end

      context 'returns invalid match record' do
        it 'if game not found' do
          expect(Match.initialize_with_results(0, foo_results).valid?).to eq(false)
        end

        it 'if results player not found' do
          expect(Match.initialize_with_results(foo_game.id, { 0 => true }).valid?).to eq(false)
        end
      end
    end

    context '#create_with_results' do
      it 'creates match results' do
        expect { Match.create_with_results(foo_game.id, foo_results) }.to change { Match.count }.by(1)
      end

      it 'creates match player results' do
        expect { Match.create_with_results(foo_game.id, foo_results) }.to change { MatchPlayer.count }.by(foo_results.length)
      end
    end
  end

  context '#played_on' do
    let(:default_format) { '%m/%d/%Y' }
    let(:custom_format) { '%Y-%m-%d' }

    it 'returns `created_at` date with default format' do
      expect(foo_match.played_on).to eq(foo_match.created_at.strftime(default_format))
    end

    it 'returns `created_at` date with custom format' do
      expect(foo_match.played_on(custom_format)).to eq(foo_match.created_at.strftime(custom_format))
    end
  end

  context '#match_winners' do
    let(:match) { create(:match_with_players) }
    let(:match_winner) { create(:match_player, match: match, winner: true) }

    it 'returns empty if match has no winners' do
      expect(match.match_winners).to be_empty
    end

    it 'returns list of match winners' do
      match_winner
      expect(match.match_winners).to eq(MatchPlayer.where(match: match, winner: true))
    end
  end

  context '#standings' do
    let(:match) { foo_match }
    let(:match_standings) { StandingsGenerators::MatchStandingsService }

    it 'instance method calls standings service with match arg' do
      expect(match_standings).to receive(:new).with(match).and_return(match_standings.new(match))
      match.standings
    end
  end
end

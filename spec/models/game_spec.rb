require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:foo_game) { create(:game, name: 'foo') }

  let(:game_without_matches) { create(:game) }
  let(:game_with_matches) { create(:game_with_matches) }

  context 'relations' do
    it { is_expected.to have_many(:matches) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }

    context 'uniqueness' do
      subject { foo_game }
      it { is_expected.to validate_uniqueness_of(:slug).case_insensitive }
    end
  end

  context '#find_by_name' do
    it 'returns `nil` if no game found' do
      expect(Game.find_by_name('foo')).to eq(nil)
    end

    it 'returns game found' do
      foo_game
      expect(Game.find_by_name('foo')).to eq(Game.find(foo_game.id))
    end
  end

  context '#find_by_similar_name' do
    it 'returns `[]` if no similar games found' do
      expect(Game.find_by_similar_name('foz').empty?).to eq(true)
    end

    it 'returns list of similar games found' do
      foo_game
      expect(Game.find_by_similar_name('fo').first).to eq(foo_game)
    end
  end

  context '#random_match' do
    it 'returns `nil` if game has no matches' do
      expect(game_without_matches.random_match).to eq(nil)
    end

    it 'returns a match record' do
      expect(game_with_matches.matches).to include(game_with_matches.random_match)
    end
  end

  context '#last_match' do
    it 'returns `nil` if game has no matches' do
      expect(game_without_matches.last_match).to eq(nil)
    end

    it 'returns latest match record' do
      expect(game_with_matches.last_match).to eq(game_with_matches.matches.first)
    end
  end

  context '#standings' do
    let(:game) { foo_game }
    let(:game_standings) { StandingsGenerators::GameStandingsService }
    let(:games_standings) { StandingsGenerators::GamesStandingsService }

    xit 'class method calls standings service with no args' do
      expect(games_standings).to receive(:new).with(no_args).and_return(games_standings.new)
      Game.standings
    end

    it 'instance method calls standings service with game arg' do
      expect(game_standings).to receive(:new).with(game).and_return(game_standings.new(game))
      game.standings
    end
  end

  context '#slug_name' do
    let(:slug_name) { 'This will be parameterized' }
    let(:slug_game) { build(:game, name: slug_name) }

    it 'parameterize\'s name' do
      expect(slug_game.send(:slug_name)).to eq(slug_name.parameterize)
    end

    it 'is triggered before save' do
      slug_game.save
      slug_game.reload

      expect(slug_game.slug).to eq(slug_name.parameterize)
    end
  end
end

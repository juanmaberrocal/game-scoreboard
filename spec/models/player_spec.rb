require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:foo_player) { create(:player, first_name: 'foo', last_name: 'bar', nickname: 'foobar', email: 'foo@bar.com' )}

  let(:player_without_matches) { create(:player) }
  let(:player_with_matches) { create(:player_with_matches) }

  context 'relations' do
    it { is_expected.to have_many(:matches) }
    it { is_expected.to have_many(:match_players) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:nickname) }
    it { is_expected.to validate_presence_of(:email) }

    context 'uniqueness' do
      subject { foo_player }
      it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end
  end

  context '#find_by_name' do
    it 'returns `nil` if no player found' do
      expect(Player.find_by_name('foo')).to eq(nil)
    end

    it 'returns player found by nickname' do
      foo_player
      expect(Player.find_by_name('foobar')).to eq(Player.find(foo_player.id))
    end

    it 'returns player found by full name' do
      foo_player
      expect(Player.find_by_name('foo bar')).to eq(Player.find(foo_player.id))
    end
  end

  context '#full_name' do
    it 'returns `first_name` and `last_name`' do
      expect(foo_player.full_name).to eq("#{foo_player.first_name} #{foo_player.last_name}")
    end
  end

  context '#player_name' do
    context 'with `use_full_name`' do
      it 'returns `first_name` and `last_name` (#full_name)' do
        expect(foo_player.player_name(true)).to eq(foo_player.full_name)
      end
    end

    context 'without `use_full_name`' do
      it 'returns `nickname`' do
        expect(foo_player.player_name(false)).to eq(foo_player.nickname)
      end
    end
  end

  context '#last_match' do
    it 'returns `nil` if player has no matches' do
      expect(player_without_matches.last_match).to eq(nil)
    end

    it 'returns latest match record' do
      expect(player_with_matches.last_match).to eq(player_with_matches.matches.first)
    end
  end

  context '#standings' do
    let(:player) { foo_player }
    let(:player_standings) { StandingsGenerators::PlayerStandingsService }
    let(:players_standings) { StandingsGenerators::PlayersStandingsService }

    it 'class method calls standings service with no args' do
      expect(players_standings).to receive(:new).with(no_args).and_return(players_standings.new)
      Player.standings
    end

    it 'instance method calls standings service with player arg' do
      expect(player_standings).to receive(:new).with(player).and_return(player_standings.new(player))
      player.standings
    end
  end
end

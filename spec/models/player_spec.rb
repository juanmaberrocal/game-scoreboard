require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Player, type: :model do
  let(:player) { create(:player) }
  let(:admin_player) { create(:player, role: 'admin') }
  let(:foo_player) { create(:player, first_name: 'foo', last_name: 'bar', nickname: 'foobar', email: 'foo@bar.com') }

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

  context 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context 'not logged in' do
      %w[game match player].each do |model|
        context "to handle `#{model.classify}`" do
          %i[read create update delete].each do |action|
            it { is_expected.to_not be_able_to(action, model.classify.constantize.new) }
          end
        end
      end
    end

    context 'logged in as player' do
      let(:user) { player }

      it { is_expected.to be_able_to(:create, Match.new) }
      it { is_expected.to be_able_to(:update, player) }

      %w[game match player].each do |model|
        context "to handle `#{model.classify}`" do
          %i[read].each do |action|
            it { is_expected.to be_able_to(action, model.classify.constantize.new) }
          end

          %i[create update delete].each do |action|
            next if action == :create && model == 'match'

            it { is_expected.to_not be_able_to(action, model.classify.constantize.new) }
          end
        end
      end
    end

    context 'logged in as admin' do
      let(:user) { admin_player }

      %w[game match player].each do |model|
        context "to handle `#{model.classify}`" do
          %i[read create update delete].each do |action|
            it { is_expected.to be_able_to(action, model.classify.constantize.new) }
          end
        end
      end
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

  context '#statistics' do
    let(:player) { foo_player }
    let(:player_statistics) { StatisticsGenerators::PlayerStatisticsService }

    it 'instance method calls statistics service with player arg' do
      expect(player_statistics).to receive(:new).with(player).and_return(player_statistics.new(player))
      player.statistics
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

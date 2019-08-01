require 'rails_helper'

RSpec.describe MatchPlayer, type: :model do
  let(:foo_match_player) { create(:match_player, player: foo_player) }
  let(:foo_player) { create(:player) }

  context 'relations' do
    it { is_expected.to belong_to(:match) }
    it { is_expected.to belong_to(:player) }
  end

  context '#player_name' do
    it 'returns players `nickname`' do
      expect(foo_match_player.player_name).to eq(foo_player.player_name(false))
    end

    it 'returns players `full_name`' do
      expect(foo_match_player.player_name(true)).to eq(foo_player.player_name(true))
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchPlayer, type: :model do
  let(:match_player) { create(:match_player, player: player) }
  let(:player) { create(:player) }

  include_examples('WithStatus Concern', :match_player, :result_status)

  context 'relations' do
    it { is_expected.to belong_to(:match) }
    it { is_expected.to belong_to(:player) }
  end

  context '#player_name' do
    it 'returns players `nickname`' do
      expect(match_player.player_name).to eq(player.player_name(false))
    end

    it 'returns players `full_name`' do
      expect(match_player.player_name(true)).to eq(player.player_name(true))
    end
  end
end

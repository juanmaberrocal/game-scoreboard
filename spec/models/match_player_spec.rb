require 'rails_helper'

RSpec.describe MatchPlayer, type: :model do
  let(:match_player) { create(:match_player, player: player) }
  let(:player) { create(:player) }

  context 'relations' do
    it { is_expected.to belong_to(:match) }
    it { is_expected.to belong_to(:player) }
  end

  context 'validations' do
    context 'result_status' do
      let(:pending_match_player) { create(:match_player, result_status: :pending) }
      let(:confirmed_match_player) { create(:match_player, result_status: :confirmed) }
      let(:rejected_match_player) { create(:match_player, result_status: :rejected) }

      context 'updated to `confirmed`' do
        it 'succeeds if `pending`' do
          pending_match_player.update(result_status: :confirmed)
          expect(pending_match_player.errors.include?(:result_status)).to eq(false)
        end

        it 'fails if not `pending`' do
          rejected_match_player.update(result_status: :confirmed)
          expect(rejected_match_player.errors.include?(:result_status)).to eq(true)
        end
      end

      context 'updated to `rejected`' do
        it 'succeeds if `pending`' do
          pending_match_player.update(result_status: :rejected)
          expect(pending_match_player.errors.include?(:result_status)).to eq(false)
        end

        it 'fails if not `pending`' do
          confirmed_match_player.update(result_status: :rejected)
          expect(confirmed_match_player.errors.include?(:result_status)).to eq(true)
        end
      end

      it 'updated to `pending` fails' do
        confirmed_match_player.update(result_status: :pending)
        expect(confirmed_match_player.errors.include?(:result_status)).to eq(true)
      end
    end
  end

  context 'scopes' do
    %i[pending confirmed rejected].each do |scope_status|
      it "filter by `result_status`=`#{scope_status}`" do
        scope_count = rand(1..5)
        
        create_list(:match_player, scope_count, result_status: scope_status)
        create_list(:match_player, rand(1..5), result_status: scope_status == :pending ? :confirmed : :pending)

        expect(MatchPlayer.send(scope_status).count).to eq(scope_count)
      end
    end
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

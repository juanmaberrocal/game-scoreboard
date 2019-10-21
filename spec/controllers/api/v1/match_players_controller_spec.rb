require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Api::V1::MatchPlayersController, type: :controller do
  let(:admin) { create(:player, :admin) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MatchPlayersController. Be sure to keep this updated too.
  let(:valid_session) { request.headers.merge!(auth_headers(admin)) }

  before(:each) { valid_session }

  describe "PUT #update" do
    context "with valid params" do
      let(:pending_match_player) { create(:match_player, result_status: :pending) }
      let(:updated_status) { 'confirmed' }
      let(:valid_update_params) {
        {
          result_status: updated_status
        }
      }

      it "changes the `result_status`" do
        put :update, params: { id: pending_match_player.id, match_player: valid_update_params }
        pending_match_player.reload
        expect(pending_match_player.result_status).to eq(updated_status)
      end
    end

    context "with invalid params" do
      let(:confirmed_match_player) { create(:match_player, result_status: :confirmed) }
      let(:updated_status) { 'pending' }
      let(:invalid_update_params) {
        {
          result_status: updated_status
        }
      }

      it "does not change the `result_status`" do
        put :update, params: { id: confirmed_match_player.id, match_player: invalid_update_params }
        confirmed_match_player.reload
        expect(confirmed_match_player.result_status).to_not eq(updated_status)
      end
    end
  end

end

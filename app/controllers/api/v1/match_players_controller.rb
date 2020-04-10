# frozen_string_literal: true

module Api
  module V1
    class MatchPlayersController < ApiController
      before_action :set_match_player, only: %i[show confirm reject]

      # GET /matches/1/match_players
      def index
        @match = Match.find(params[:match_id])
        @match_players = @match.match_players

        render json: @match_players
      end

      # GET /match_players/1
      def show
        render json: @match
      end

      # POST /match_players/1/confirm
      def confirm
        authorize! :confirm, @match_player

        if @match_player.confirmed!
          render json: @match_player
        else
          unprocessable_entity!(@match_player)
        end
      end

      # POST /match_players/1/reject
      def reject
        authorize! :reject, @match_player

        if @match_player.rejected!
          render json: @match_player
        else
          unprocessable_entity!(@match_player)
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_match_player
        @match_player = MatchPlayer.find(params[:id])
      end
    end
  end
end

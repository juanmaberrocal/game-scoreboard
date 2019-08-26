module Api
  module V1
    class MatchPlayersController < ApiController
      before_action :set_match_player, only: [:show, :update, :destroy]

      # GET /match_players
      def index
        @match_players = MatchPlayer.all
        @match_players = @match_players.where(player_id: params[:player_id]) if params[:player_id].present?

        render json: @match_players
      end

      # GET /match_players/1
      def show
        render json: @match_player
      end

      # POST /match_players
      def create
        @match_player = MatchPlayer.new(match_player_params)

        if @match_player.save
          render json: @match_player, status: :created, location: @match_player
        else
          render json: @match_player.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /match_players/1
      def update
        if @match_player.update(match_player_params)
          render json: @match_player
        else
          render json: @match_player.errors, status: :unprocessable_entity
        end
      end

      # DELETE /match_players/1
      def destroy
        @match_player.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_match_player
          @match_player = MatchPlayer.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def match_player_params
          params.require(:match_player).permit(:match_id, :player_id, :winner)
        end
    end
  end
end

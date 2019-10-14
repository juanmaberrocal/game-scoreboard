module Api
  module V1
    class MatchPlayersController < ApiController
      before_action :set_match, only: [:update]

      # PATCH/PUT /match_players/1
      def update
        if @match_player.update(match_params)
          render json: @match_player
        else
          raise ApiError::UnprocessableEntity.new(params[:controller], params[:action], @match_player.errors)
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_match
          @match_player = MatchPlayer.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def match_params
          params.require(:match_player).permit(:result_status)
        end

        def validate_update
          validations = {
            result_status: [:required, String],
          }

          validate_params(validations)
        end
      end
    end
  end
end

module Api
  module V1
    class MatchesController < ApiController
      before_action :set_match, only: [:show, :update, :destroy]

      # GET /matches
      def index
        if params[:game_id].present?
          @game = Game.find_by(id: params[:game_id])
          @matches = @game.matches

          render json: MatchSerializer.new(@matches, params: { game_id: params[:game_id] })
        elsif params[:player_id].present?
          @player = Player.find_by(id: params[:player_id])
          @matches = @player.matches.select('matches.*', 'match_players.winner')

          render json: MatchSerializer.new(@matches, params: { player_id: params[:player_id] })
        else
          @matches = Match.all
          render json: @matches
        end
      end

      # GET /matches/1
      def show
        render json: @match
      end

      # POST /matches
      def create
        @match = Match.new(match_params)

        if @match.save
          render json: @match, status: :created, location: @match
        else
          render json: @match.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /matches/1
      def update
        if @match.update(match_params)
          render json: @match
        else
          render json: @match.errors, status: :unprocessable_entity
        end
      end

      # DELETE /matches/1
      def destroy
        @match.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_match
          @match = Match.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def match_params
          params.require(:match).permit(:game_id)
        end
    end
  end
end

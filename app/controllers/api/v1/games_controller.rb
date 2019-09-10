module Api
  module V1
    class GamesController < ApiController
      before_action :set_game, only: [:show, :standings, :update, :destroy]

      # GET /games
      def index
        @games = Game.all

        render json: @games, params: { public: params[:public] }
      end

      # GET /games/1
      def show
        render json: @game
      end

      def standings
        render json: StandingsSerializer.new(@game)
      end

      # POST /games
      def create
        @game = Game.new(game_params)

        if @game.save
          render json: @game, status: :created, location: @game
        else
          render json: @game.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /games/1
      def update
        if @game.update(game_params)
          render json: @game
        else
          render json: @game.errors, status: :unprocessable_entity
        end
      end

      # DELETE /games/1
      def destroy
        @game.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_game
          @game = Game.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def game_params
          params.require(:game).permit(:name, :description, :min_players, :max_players, :min_play_time, :max_play_time)
        end
    end
  end
end

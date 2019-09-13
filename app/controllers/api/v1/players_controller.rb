module Api
  module V1
    class PlayersController < ApiController
      before_action :set_player, only: [:show, :standings, :update, :destroy]

      # GET /players
      def index
        @players = Player.all

        render json: @players, params: { public: params[:public] }
      end

      # GET /players/1
      def show
        render json: @player
      end

      def standings
        render json: StandingsSerializer.new(@player)
      end

      # POST /players
      def create
        @player = Player.new(player_params)

        if @player.save
          render json: @player, status: :created, location: @player
        else
          render json: @player.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /players/1
      def update
        if @player.update(player_params)
          render json: @player
        else
          render json: @player.errors, status: :unprocessable_entity
        end
      end

      # DELETE /players/1
      def destroy
        @player.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_player
          @player = Player.find(params[:id])
        end

        # Only allow a trusted parameter "white list" through.
        def player_params
          params.require(:player).permit(:first_name, :last_name, :email,
                                         :nickname, :birth_date, :avatar)
        end
    end
  end
end

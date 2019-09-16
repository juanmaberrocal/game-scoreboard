module Api
  module V1
    class MatchesController < ApiController
      before_action :set_match, only: [:show, :update, :destroy]

      # GET /matches
      def index
        if params[:game_id].present?
          @game = Game.find_by(id: params[:game_id])
          @matches = @game.matches.select('matches.*', 'match_players.winner')

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
        game    = match_params[:game_name]
        results = match_params[:results].map { |r| r.to_h }

        @match = Match.initialize_with_results(game, results)

        if @match&.save
          render json: MatchSerializer.new(@match, params: { with_results: true }),
                 status: :created
        else
          if @match.present?
            raise ApiError::UnprocessableEntity.new(params[:controller], params[:action], @match.errors)
          else
            raise GeneralApiError.new(params[:controller], params[:action],
                                      'Match could not be recorded. '\
                                      'Make sure the game and players selected are correct.')
          end
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
          results_keys = params[:match][:results].map { |r| r.keys }.flatten
          params.require(:match).permit(:game_name, results: results_keys)
        end

        def validate_create
          validations = {
            game_name: [:required, String],
            results: [:required, Array]
          }

          validate_params(validations)
        end
    end
  end
end

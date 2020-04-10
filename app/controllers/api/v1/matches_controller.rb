# frozen_string_literal: true

module Api
  module V1
    class MatchesController < ApiController
      before_action :set_match, only: %i[update destroy]

      # GET /matches
      def index
        if params[:game_id].present?
          @game = Game.find_by(id: params[:game_id])
          @matches = @game.matches.select('matches.*', 'match_players.winner')

          render json: @matches, params: { game_id: params[:game_id] }
        elsif params[:player_id].present?
          @player = Player.find_by(id: params[:player_id])
          @matches = Match.includes(:match_players)
                          .where(match_players: { player: @player })

          render json: @matches, params: { player_id: params[:player_id] },
                                 include: [:match_players]
        else
          @matches = Match.all
          render json: @matches
        end
      end

      # GET /matches/1
      def show
        @match = Match.includes(:match_players).find(params[:id])
        render json: @match, include: [:match_players]
      end

      # POST /matches
      def create
        @match = Match.initialize_with_results(match_params[:game_id],
                                               match_params[:results].to_hash)

        if @match.save
          render json: @match, params: { with_results: true }, status: :created
        else
          unprocessable_entity!(@match)
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_match
        @match = Match.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def match_params
        results_keys = params[:match][:results].keys
        params.require(:match).permit(:game_id, results: results_keys)
      end

      def validate_create
        validations = {
          game_id: [:required, Integer],
          results: [:required, Hash]
        }

        validate_params(validations)
      end
    end
  end
end

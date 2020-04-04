# frozen_string_literal: true

module Api
  module V1
    class MatchesController < ApiController
      before_action :set_match, only: %i[show update destroy]

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
        @match = Match.initialize_with_results(match_params[:game_id],
                                               match_params[:results].to_hash)

        if @match.save
          render json: @match, params: { with_results: true }, status: :created
        else
          unprocessable_entity!(@match)
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

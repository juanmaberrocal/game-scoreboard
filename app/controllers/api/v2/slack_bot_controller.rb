module Api
  module V2
    class SlackBotController < ApplicationController
      include SlackApi

      # Add a before_action to authenticate all requests
      before_action :authenticate

      def game_score
        set_game
        queue_response(@game.id)
        success_response
      rescue => e
        error_response(e.message)
      end

      def games_scoreboard
      end

      def match_score
        set_game
        queue_response(@game.id)
        success_response
      rescue => e
        error_response(e.message)
      end

      def player_score
        set_player
        queue_response(@player.id)
        success_response
      rescue => e
        error_response(e.message)
      end

      def player_scoreboard
        queue_response
        success_response
      rescue => e
        error_response(e.message)
      end

      private

      def set_game
        @game = Game.find_by_name(params[:text])
        raise InvalidGameRequest.new(params[:text]) unless @game.present?
      end

      def set_player
        @player = Player.find_by_name(params[:text])
        raise InvalidPlayerRequest.new(params[:text]) unless @player.present?
      end

      def queue_response(*args)
        SlashCommandResponseJob.perform_later(params[:command],
                                              params[:response_url],
                                              params[:user_id],
                                              *args)
      end
    end
  end
end

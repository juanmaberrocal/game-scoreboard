module Api
  module V1
    class SlackBotController < ApplicationController
      before_action :authenticate

      def authorize; end

      def game_score
        # SlashCommandResponseJob.perform_later()
      end

      def games_scoreboard
      end

      private

      def authenticate
        authenticate_token || render_unauthorized
      end

      def authenticate_token
      end

      def render_unauthorized
      end
    end
  end
end

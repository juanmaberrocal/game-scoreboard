module Api
  module V2
    class SlashCommandController < ApplicationController
      include SlackApi

      # Add a before_action to authenticate all requests
      before_action :authenticate, :validate

      # /command {action}:{model} [params]
      # |------| => params[:command]
      #          |-----------------------| => params[:text]
      def game_scoreboard
        queue_response
        success_response
      rescue => e
        error_response(e.message)
      end

      private

      def queue_response
        SlashCommandActionJob.perform_later(params[:response_url],
                                            params[:user_id],
                                            params[:text])
      end
    end
  end
end

module Api
  module V1
    class SlackBotController < ApplicationController
      # Add a before_action to authenticate all requests
      before_action :authenticate

      # def authorize; end

      def game_score
        set_game
        queue_response(@game.id)
        success_response
      rescue => e
        error_response(e.message)
      end

      def games_scoreboard
      end

      private

      DEFAULT_RESPONSE_TYPE = 'ephemeral'.freeze
      DEFAULT_SUCCESS_TEXT  = 'Awesome, pulling results. Please wait a minute.'.freeze
      DEFAULT_ERROR_TEXT    = 'Sorry, that didn\'t work. Please try again.'.freeze

      def set_game
        @game = Game.find_by(name: params[:text])
        raise InvalidGameRequest.new(params[:text]) unless @game.present?
      end

      def queue_response(*args)
        SlashCommandResponseJob.perform_later(params[:command],
                                              params[:response_url],
                                              params[:user_id],
                                              *args)
      end

      def success_response(text = DEFAULT_SUCCESS_TEXT, response_type = DEFAULT_RESPONSE_TYPE, attachments = [])
        slack_response(text, response_type, attachments)
      end

      def error_response(text = DEFAULT_ERROR_TEXT, response_type = DEFAULT_RESPONSE_TYPE, attachments = [])
        slack_response(text, response_type, attachments)
      end

      def slack_response(text, response_type, attachments)
        json_response = { response_type: response_type, text: text }
        json_response[:attachments] = attachments if attachments.present?

        render json: json_response, status: 200
      end

      def slack_signature
        headers['X-Slack-Signature']
      end

      def slack_timestamp
        headers['X-Slack-Request-Timestamp']
      end

      def slack_body
        body
      end

      protected

      # Authenticate the slash command with signature based authentication
      def authenticate
        SlackRequestAuthenticator.new(slack_signature, slack_timestamp, slack_body)
                                 .authenticate!
      rescue InvalidSlackRequest => e
        error_response(e.message)
      rescue => e
        error_response
      end
    end
  end
end

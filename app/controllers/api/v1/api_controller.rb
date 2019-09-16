module Api
  module V1
    class ApiController < ApplicationController
      before_action :authenticate_player!
      before_action :validate_request!

      rescue_from GeneralApiError, with: :handle_api_error
      rescue_from ApiError::InvalidParams, with: :handle_invalid_api_params

      def render(options = {})
        unless options[:error]
          options[:json] = serializer.new(options[:json],
                                          options.reject { |k, _| k == :json }) if unserialzed?(options[:json].class) &&
                                                                                   serializer?
        end

        super(options)
      end

      private

      # params validation helpers
      def validate_request!
        return unless respond_to?("validate_#{params[:action]}".to_sym, true)
        send("validate_#{params[:action]}".to_sym)
      end

      def validate_params(params_to_validate)
        params_root = params[controller_name.singularize]
        invalid_param = nil

        params_to_validate.each do |param, validations|
          validations.each do |validation|
            invalid_param = case validation
                            when :required
                              param unless params_root[param].present?
                            else
                              param unless params_root[param].is_a?(validation)
                            end

            break if invalid_param.present?
          end

          break if invalid_param.present?
        end

        raise ApiError::InvalidParams.new(params[:controller],
                                          params[:action],
                                          invalid_param,
                                          params_root[invalid_param]) if invalid_param.present?
      end

      # fast_jsonapi Serializer helpers
      def serializer
        @serializer ||= "#{controller_name.singularize}_serializer".camelize
                                                                   .safe_constantize
      end

      def serializer?
        serializer.present?
      end
      
      def unserialzed?(klass)
        !(klass < FastJsonapiSerializer)
      end

      # error rescues
      def handle_invalid_api_params(exception)
        render json: { error: exception.message }, 
               status: :bad_request,
               error: true
      end

      def handle_api_error(exception)
        render json: { error: exception.message },
               status: :internal_server_error,
               error: true
      end
    end
  end
end

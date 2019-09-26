module Api
  module V1
    class ApiController < ApplicationController
      include ApiErrorHandling

      alias_method :current_user, :current_player

      before_action :authenticate_player!
      before_action :authorize_request!
      before_action :validate_request!

      check_authorization

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
                              if validation == Hash
                                param unless params_root[param].is_a?(ActionController::Parameters)
                              else
                                param unless params_root[param].is_a?(validation)
                              end
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

      # cancan role authorization
      def authorize_request!
        klass = controller_name.singularize.camelize.safe_constantize
        authorize! params[:action].to_sym, klass
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
    end
  end
end

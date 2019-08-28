module Api
  module V1
    class ApiController < ApplicationController
      # before_action :authenticate_player!

      def render(options = {})
        options[:json] = serializer.new(options[:json],
                                        options.reject { |k, _| k == :json }) if unserialzed?(options[:json].class) &&
                                                                                 serializer?
        super(options)
      end

      private

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

module Api
  module V1
    class ApiController < ApplicationController
      before_action :authenticate_player!

      def render(options = {})
        options[:json] = serializer.new(options[:json]) if serializer?
        super(options)
      end

      private

      def serializer
        "#{controller_name.singularize}_serializer".camelize.safe_constantize
      end

      def serializer?
        serializer.present?
      end
    end
  end
end

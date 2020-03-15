# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from GeneralApiError,
                with: :handle_internal_server_error

    rescue_from ActiveRecord::RecordNotFound,
                with: :handle_not_found

    rescue_from CanCan::AccessDenied,
                with: :handle_forbidden

    rescue_from ActionController::ParameterMissing,
                with: :handle_bad_request
    rescue_from ActionController::UrlGenerationError,
                with: :handle_method_not_allowed
    rescue_from ActionController::RoutingError,
                with: :handle_method_not_allowed
  end

  private

  %i[
    internal_server_error
    bad_request
    unprocessable_entity
    not_found
    forbidden
    method_not_allowed
  ].each do |error_code|
    define_method("handle_#{error_code}".to_sym) do |exception|
      api_rollbar(exception)
      render json: { error: exception.message },
             status: error_code,
             error: true
    end
  end

  def api_rollbar(error)
    Rollbar.error(error,
                  error.message,
                  controller: params[:controller],
                  action: params[:action])
  end
end

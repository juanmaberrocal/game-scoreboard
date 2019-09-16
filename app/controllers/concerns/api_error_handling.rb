module ApiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from GeneralApiError, with: :handle_general_error
    rescue_from ApiError::InvalidParams, with: :handle_invalid_params
    rescue_from ApiError::UnprocessableEntity, with: :handle_unprocessable_entity
  end

  private

  def handle_general_error(exception)
    api_rollbar(exception)
    render json: { error: exception.message },
           status: :internal_server_error,
           error: true
  end

  def handle_invalid_params(exception)
    api_rollbar(exception)
    render json: { error: exception.message }, 
           status: :bad_request,
           error: true
  end

  def handle_unprocessable_entity(exception)
    api_rollbar(exception)
    render json: { error: exception.message },
           status: :unprocessable_entity,
           error: true
  end

  def api_rollbar(e)
    Rollbar.error(e, e.message, controller: params[:controller], action: params[:action])
  end
end

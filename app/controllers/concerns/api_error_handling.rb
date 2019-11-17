# frozen_string_literal: true

module ApiErrorHandling
  extend ActiveSupport::Concern

  include ErrorHandling

  included do
    rescue_from ApiError::InvalidParams,
                with: :handle_bad_request
    rescue_from ApiError::UnprocessableEntity,
                with: :handle_unprocessable_entity
  end
end

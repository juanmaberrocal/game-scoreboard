# frozen_string_literal: true

module DeviseErrorHandling
  extend ActiveSupport::Concern

  include ErrorHandling

  included do
    rescue_from DeviseError::MissingParams,
                with: :handle_bad_request
    rescue_from DeviseError::UnprocessableEntity,
                with: :handle_unprocessable_entity
  end
end

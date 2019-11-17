# frozen_string_literal: true

module DeviseApi
  extend ActiveSupport::Concern

  include DeviseErrorHandling

  included do
    respond_to :json
  end

  private

  def missing_param!(param)
    raise DeviseError::MissingParams.new(params[:controller],
                                         params[:action],
                                         param)
  end

  def unprocessable_entity!(resource)
    raise DeviseError::UnprocessableEntity.new(params[:controller],
                                               params[:action],
                                               resource)
  end

  def respond_with(resource, _opts = {})
    render json: PlayerSerializer.new(resource)
  end
end

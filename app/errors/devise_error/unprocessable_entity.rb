# frozen_string_literal: true

module DeviseError
  class UnprocessableEntity < GeneralApiError
    attr_reader :errors

    def initialize(controller, action, resource, custom_message = '')
      @errors = resource.errors
      super(controller, action, custom_message)
    end

    def message
      super +
        errors.full_messages.join(' & ')
    end
  end
end

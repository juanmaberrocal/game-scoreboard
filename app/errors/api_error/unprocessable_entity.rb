module ApiError
  class UnprocessableEntity < GeneralApiError
    attr_reader :errors

    def initialize(controller, action, errors, custom_message = '')
      @errors = errors
      super(controller, action, custom_message)
    end

    def message
      super +
      errors.full_messages.join(' & ')
    end
  end
end

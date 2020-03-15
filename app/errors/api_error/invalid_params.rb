module ApiError
  class InvalidParams < GeneralApiError
    attr_reader :param, :value

    def initialize(controller, action, param, value, custom_message = '')
      @param = param
      @value = value
      super(controller, action, custom_message)
    end

    def message
      super +
        "Invalid `#{param}` value: `#{value}`."
    end
  end
end

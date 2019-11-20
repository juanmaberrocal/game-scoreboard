# frozen_string_literal: true

module DeviseError
  class MissingParams < GeneralApiError
    attr_reader :param

    def initialize(controller, action, param, custom_message = '')
      @param = param
      super(controller, action, custom_message)
    end

    def message
      super +
        "Missing `#{param}` value."
    end
  end
end

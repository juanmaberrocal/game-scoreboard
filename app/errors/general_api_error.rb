# frozen_string_literal: true

class GeneralApiError < StandardError
  attr_reader :controller, :action,
              :custom_message

  def initialize(controller, action, custom_message = '')
    @controller = controller
    @action     = action
    @custom_message = custom_message
    super()
  end

  def message
    "There was an error processing the request to #{controller}##{action}. "\
    "#{custom_message}"
  end
end

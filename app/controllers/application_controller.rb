class ApplicationController < ActionController::API
  def headers
    request.headers
  end

  def body
    request.body.read
  end
end

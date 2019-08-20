require 'devise/jwt/test_helpers'

module JwtTestHelper
  def current_player(player = nil)
    @current_player ||= (player || create(:player))
  end

  def auth_headers(player = nil)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    # This will add a valid token for `player` in the `Authorization` header
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, current_player(player))
  end
end

RSpec.configure do |config|
  config.include JwtTestHelper, type: :request
end

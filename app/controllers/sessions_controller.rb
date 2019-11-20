# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  include DeviseApi

  def renew
    authenticate_player!
    render json: PlayerSerializer.new(current_player), status: 200
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end

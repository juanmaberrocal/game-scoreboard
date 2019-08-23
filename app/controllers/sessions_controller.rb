class SessionsController < Devise::SessionsController
  respond_to :json

  def renew
    authenticate_player!
    render json: PlayerSerializer.new(current_player), status: 200
  end

  private

  def respond_with(resource, _opts = {})
    render json: PlayerSerializer.new(resource)
  end

  def respond_to_on_destroy
    head :no_content
  end
end

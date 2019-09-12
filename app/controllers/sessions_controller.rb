class SessionsController < Devise::SessionsController
  respond_to :json

  def renew
    authenticate_player!
    render json: PlayerSerializer.new(current_player), status: 200
  end

  def update_password
    authenticate_player!
    update_password_params = params.require(:player).permit(:current_password,
                                                            :password, :password_confirmation)

    if current_player.update_with_password(update_password_params)
      render json: PlayerSerializer.new(current_player)
    else
      render json: current_player.errors, status: :unprocessable_entity
    end
  end

  def reset_password; end

  private

  def respond_with(resource, _opts = {})
    render json: PlayerSerializer.new(resource)
  end

  def respond_to_on_destroy
    head :no_content
  end
end

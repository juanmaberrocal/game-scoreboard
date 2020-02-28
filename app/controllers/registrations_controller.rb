# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  include DeviseApi

  def create
    super do |resource|
      unprocessable_entity!(resource) unless resource.persisted?
    end
  end

  def update_password
    authenticate_player!

    if current_player.update_with_password(update_password_params)
      render json: PlayerSerializer.new(current_player)
    else
      unprocessable_entity!(current_player)
    end
  end

  def reset_password; end

  private

  REQ_CREATE_PARAMS = %i[
    email
    password
    password_confirmation
    nickname
    first_name
    last_name
  ].freeze

  def sign_up_params
    sanitize_sign_up_params

    player_params = super
    validate_sign_up_params(player_params)

    player_params
  end

  def sanitize_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |player_params|
      player_params.permit(*REQ_CREATE_PARAMS)
    end
  end

  def validate_sign_up_params(player_params)
    missing_params = REQ_CREATE_PARAMS - player_params.keys
                                                      .map(&:to_sym)

    missing_params.each do |missing_param|
      missing_param!(missing_param)
    end
  end

  def update_password_params
    params.require(:player).permit(:current_password,
                                   :password,
                                   :password_confirmation)
  end
end

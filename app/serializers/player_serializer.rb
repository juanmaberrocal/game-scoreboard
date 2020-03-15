# frozen_string_literal: true

class PlayerSerializer < FastJsonapiSerializer
  attributes :nickname

  attributes :email,
             :first_name,
             :last_name,
             :role, if: proc { |_player, params|
               params[:public]&.to_bool.blank?
             }

  attribute :avatar_url, if: proc { |player, _params|
    player.avatar.attached?
  } do |player|
    if Rails.env.production?
      player.avatar.variant(resize_to_limit: [100, 100]).processed.service_url
    else
      # ActiveStorage::Blob.service.send(:path_for, player.avatar.key)
      nil
    end
  end
end

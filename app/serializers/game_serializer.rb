class GameSerializer < FastJsonapiSerializer
  attributes :name

  attributes :description,
             :min_players,
             :max_players,
             :min_play_time,
             :max_play_time, if: Proc.new { |game, params|
    params[:public]&.to_bool.blank?
  }

  attribute :avatar_url, if: Proc.new { |game, params|
    game.avatar.attached?
  } do |player|
    if Rails.env.production?
      game.avatar.variant(resize_to_limit: [200, 100]).processed.service_url
    else
      # ActiveStorage::Blob.service.send(:path_for, game.avatar.key)
      nil
    end
  end
end

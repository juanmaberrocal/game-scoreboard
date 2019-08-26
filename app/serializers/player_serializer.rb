class PlayerSerializer < FastJsonapiSerializer
  attributes :nickname

  attributes :email,
             :first_name,
             :last_name, if: Proc.new { |player, params|
    params[:public]&.to_bool.blank?
  }
end

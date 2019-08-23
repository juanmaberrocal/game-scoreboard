class PlayerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email,
             :first_name,
             :last_name,
             :nickname
end

class PlayerSerializer < FastJsonapiSerializer
  attributes :email,
             :first_name,
             :last_name,
             :nickname
end

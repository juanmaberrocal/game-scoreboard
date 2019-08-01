FactoryBot.define do
  factory :match_player do
    match
    player
    winner { false }
  end
end

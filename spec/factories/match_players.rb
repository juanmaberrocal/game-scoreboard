FactoryBot.define do
  factory :match_player do
    match { nil }
    player { nil }
    winner { false }
  end
end

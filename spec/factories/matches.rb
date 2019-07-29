FactoryBot.define do
  factory :match do
    game

    factory :match_with_players do
      transient do
        player_count { 3 }

        after(:create) do |match, evaluator|
          create_list(:player, evaluator.player_count, match: match)
        end
      end
    end
  end
end

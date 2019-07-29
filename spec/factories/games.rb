FactoryBot.define do
  factory :game do
    name { Faker::Game.unique.title }
    description { "MyText" }
    min_players { 1 }
    max_players { 2 }

    factory :game_with_matches do
      transient do
        match_count { 3 }

        after(:create) do |game, evaluator|
          create_list(:match, evaluator.match_count, game: game)
        end
      end
    end
  end
end

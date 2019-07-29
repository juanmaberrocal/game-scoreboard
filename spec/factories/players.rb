FactoryBot.define do
  factory :player do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    birth_date { Faker::Date.birthday }
    nickname { Faker::FunnyName.unique.name }

    factory :player_with_matches do
      transient do
        match_count { 3 }

        after(:create) do |player, evaluator|
          create_list(:match_player, evaluator.match_count, player: player)
        end
      end
    end
  end
end

FactoryBot.define do
  factory :player do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birth_date { Faker::Date.birthday }
    nickname { Faker::FunnyName.unique.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.unique.password }

    trait :admin do
      role { :admin }
    end

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

# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birth_date { Faker::Date.birthday }
    nickname { Faker::FunnyName.unique.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }

    trait :admin do
      role { :admin }
    end

    factory :player_with_matches do
      transient do
        match_count { 3 }
        status { nil }
        match_status { status || :pending }
        result_status { status || :pending }

        after(:create) do |player, evaluator|
          evaluator.match_count.times do
            create(:match_player, player: player,
                                  match: create(:match, match_status: evaluator.match_status),
                                  result_status: evaluator.result_status)
          end
        end
      end
    end
  end
end

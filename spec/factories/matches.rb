# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    game

    trait :pending do
      match_status { :pending }
    end

    trait :confirmed do
      match_status { :confirmed }
    end

    trait :rejected do
      match_status { :rejected }
    end

    factory :match_with_players do
      transient do
        player_count { 3 }

        after(:create) do |match, evaluator|
          create_list(:match_player, evaluator.player_count, match: match)
        end
      end
    end
  end
end

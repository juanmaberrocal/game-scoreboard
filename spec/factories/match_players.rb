# frozen_string_literal: true

FactoryBot.define do
  factory :match_player do
    match
    player
    winner { false }

    trait :pending do
      result_status { :pending }
    end

    trait :confirmed do
      result_status { :confirmed }
    end

    trait :rejected do
      result_status { :rejected }
    end
  end
end

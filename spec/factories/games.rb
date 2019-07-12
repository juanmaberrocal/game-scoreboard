FactoryBot.define do
  factory :game do
    name { "MyString" }
    description { "MyText" }
    min_players { 1 }
    max_players { 1 }
  end
end

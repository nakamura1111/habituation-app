FactoryBot.define do
  factory :target do
    name { Faker::Lorem.paragraph_by_chars(number: 255) }
    content { Faker::Lorem.paragraph_by_chars(number: 512) }
    point { Faker::Number.between(from: 0, to: 1_000_000_000) }
    level { Faker::Number.between(from: 0, to: 1_000_000_000) }
    exp { Faker::Number.between(from: 0, to: 1_000_000_000) }
    association :user
  end
end

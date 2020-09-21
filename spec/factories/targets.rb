FactoryBot.define do
  factory :target do
    name { Faker::Lorem.paragraph_by_chars(number: 255) }
    content { Faker::Lorem.paragraph_by_chars(number: 512) }
    point { 0 }
    level { 1 }
    exp { 0 }
    association :user
  end
end

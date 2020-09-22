FactoryBot.define do
  factory :habit do
    name { Faker::Lorem.paragraph_by_chars(number: 20) }
    content { Faker::Lorem.paragraph_by_chars(number: 50) }
    difficulty_grade { Difficulty.all.sample.id }
    achieved_or_not_binary { 0 }
    achieved_days { 0 }
    is_active { true }
    association :target
  end
end

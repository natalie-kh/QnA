FactoryBot.define do
  factory :answer do
    body { 'Answer body' }
    question
    association :user

    trait :invalid do
      body { nil }
      association :user
    end
  end
end

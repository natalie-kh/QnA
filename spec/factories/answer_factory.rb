FactoryBot.define do
  factory :answer do
    body { 'Answer body' }
    question
    association :user, factory: :user

    trait :invalid do
      body { nil }
      association :user, factory: :user
    end
  end
end

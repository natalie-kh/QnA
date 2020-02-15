FactoryBot.define do
  factory :comment do
    body { 'Comment body' }
    association :user

    trait :invalid do
      body { nil }
      association :user
    end
  end
end

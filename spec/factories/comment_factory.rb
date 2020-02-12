FactoryBot.define do
  factory :comment do
    body { 'Comment body' }
    association :user, factory: :user

    trait :invalid do
      body { nil }
      association :user, factory: :user
    end
  end
end

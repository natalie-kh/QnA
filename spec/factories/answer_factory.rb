FactoryBot.define do
  factory :answer do
    body { 'Answer body' }
    question

    trait :invalid do
      body { nil }
    end
  end
end

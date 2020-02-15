FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    association :user

    trait :invalid do
      title { nil }
      association :user
    end
  end
end

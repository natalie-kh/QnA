FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    association :user, factory: :user

    trait :invalid do
      title { nil }
      association :user, factory: :user
    end
  end
end

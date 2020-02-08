FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { 'MyProvider' }
    uid { 'MyUid' }

    trait :github do
      user { nil }
      provider { :github }
      uid { '12345' }
    end

    trait :facebook do
      user { nil }
      provider { :facebook }
      uid { '12345' }
    end
  end
end

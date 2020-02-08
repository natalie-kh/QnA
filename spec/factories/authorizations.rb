FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { 'MyProvider' }
    uid { 'MyUid' }
  end
end

FactoryBot.define do
  factory :subscription do
    association :question
    association :user
  end
end

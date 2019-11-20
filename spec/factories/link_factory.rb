FactoryBot.define do
  factory :link do
    name { 'My Link' }
    url { 'https://www.google.com' }

    trait :invalid do
      name { 'Invalid Link' }
      url { 'yandex.ru' }
    end
  end
end
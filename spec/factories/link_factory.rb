FactoryBot.define do
  factory :link do
    name { 'My Link' }
    url { 'https://www.google.com' }

    trait :invalid do
      name { 'Invalid Link' }
      url { 'yandex.ru' }
    end

    trait :gist do
      name { 'Gist' }
      url { 'https://gist.github.com/natalya-bogdanova/59312d83a6e67827186ee969dbd18ef8' }
    end
  end
end

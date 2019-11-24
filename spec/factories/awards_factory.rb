FactoryBot.define do
  factory :award do
    name { 'New Award' }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }
  end
end

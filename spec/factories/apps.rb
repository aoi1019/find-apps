FactoryBot.define do
  factory :app do
    name { "アプリ" }
    description { "インスタグラムです" }
    point { "Ruby on Railsで開発！" }
    reference { "https://find-apps.herokuapp.com/" }
    period { 10 }
    association :user
  end
  trait :picture do
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/mac.jpg')) }
  end
end

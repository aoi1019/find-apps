FactoryBot.define do
  factory :user, aliases: [:follower, :followed] do
    name { Faker::Name.name }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    profile { "はじめまして。プログラミング初心者ですが、頑張ります！" }

    trait :admin do
      admin { true }
    end
  end
end

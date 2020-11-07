FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email {Faker::Internet.free_email}
    # sequence(:email) { |n| "example#{n}@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
    profile { "はじめまして。プログラミング初心者ですが、頑張ります！" }

    trait :admin do
      admin { true }
    end
  end
end

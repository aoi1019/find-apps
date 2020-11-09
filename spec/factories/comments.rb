FactoryBot.define do
  factory :comment do
    association :user
    content { "面白いアプリですね！" }
    association :app
  end
end

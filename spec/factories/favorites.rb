FactoryBot.define do
  factory :favorite do
    association :app
    association :user
  end
end

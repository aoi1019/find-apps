FactoryBot.define do
  factory :notification do
    app_id { 1 }
    variety { 1 }
    content { "" }
    from_user_id { 2 }
    association :user
  end
end

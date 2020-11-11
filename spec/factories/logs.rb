FactoryBot.define do
  factory :log do
    content "チャット機能を追加！"
    association :app
  end
end

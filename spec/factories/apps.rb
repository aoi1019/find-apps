FactoryBot.define do
  factory :app do
    name {"アプリ"}
    description {"インスタグラムです"}
    point {"Ruby on Railsで開発！"}
    reference {"https://find-apps.herokuapp.com/"}
    period {10}
    association :user
  end
end

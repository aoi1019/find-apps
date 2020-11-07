User.create!(name:  "山田 太郎",
  email: "sample@example.com",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true)

99.times do |n|
name  = Faker::Name.name
email = "sample-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password)
end

10.times do |n|
  App.create!(name: "インスタグラム",
               description: "オリジナルアプリです",
               point: "ピリッと辛めに味付けするのがオススメ",
               reference: "https://find-apps.herokuapp.com/",
               period: 30,
               user_id: 1)
end
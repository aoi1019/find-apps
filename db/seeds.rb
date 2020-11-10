User.create!(name:  "山田 太郎",
  email: "sample@example2.com",
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
               point: "Ruby on Railsで開発",
               reference: "https://find-apps.herokuapp.com/",
               period: 30,
               user_id: 1)
  app = App.first
  Log.create!(app_id: app.id, content: app.memo)
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
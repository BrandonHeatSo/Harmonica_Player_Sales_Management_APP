# coding: utf-8

User.create!(name: "管理者",
  email: "sample@email.com",
  password: "password",
  admin: true)

5.times do |n|
name  = Faker::Name.name
email = "sample-#{n+1}@email.com"
password = "password"
User.create!(name: name,
    email: email,
    password: password)
end

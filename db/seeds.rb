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

admin_user = User.first
guest1_user = User.find(2)

content1_name = "ライブ演奏"
content2_name = "レコーディング"

description1 = "ライブサポート"
description2 = "終日レコーディング演奏"

admin_user.contents.create!(name: content1_name, description: description1)
admin_user.contents.create!(name: content2_name, description: description2)
guest1_user.contents.create!(name: content1_name, description: description1)
guest1_user.contents.create!(name: content2_name, description: description2)

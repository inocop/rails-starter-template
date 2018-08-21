# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# 初期ユーザー
User.create!(:email => "rails@example.com", :password => "password")

# 開発用seed
if Rails.env.development?
  # Projectデータ
  Project.create!(:name => 'テストプロジェクト1', :start_day => '2018-8-11')
  Project.create!(:name => 'テストプロジェクト2', :start_day => '2018-8-21')
  Project.create!(:name => 'テストプロジェクト3', :start_day => '2018-8-31')
end

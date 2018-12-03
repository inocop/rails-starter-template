# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# 初期ユーザー
User.create!(name: "管理者", email: "admin@example.com", password: "password", admin: true)
# 開発用seed
if Rails.env.development?
  user_1 = User.create!(name: "ユーザー１", email: "user1@example.com", password: "password")
  user_2 = User.create!(name: "ユーザー２", email: "user2@example.com", password: "password")
  user_3 = User.create!(name: "ユーザー３", email: "user3@example.com", password: "password")

  project_1 = Project.create!(name: "テストプロジェクト1")
  project_2 = Project.create!(name: "テストプロジェクト2")
  project_3 = Project.create!(name: "テストプロジェクト3")

  ticket_1 = Ticket.create!(name: "テストチケット1", project_id: project_1.id, assigned_user_id: user_1.id)
  ticket_2 = Ticket.create!(name: "テストチケット2", project_id: project_1.id, assigned_user_id: user_1.id)
end


# 本番運用開始後のマスタデータ変更はmigrate_seedで管理
Dir.glob("#{Rails.root}/db/migrate_seed/*_seeds.rb").each do |filename|
  require filename
end

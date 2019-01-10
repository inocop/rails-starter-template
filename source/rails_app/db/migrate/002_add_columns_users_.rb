class AddColumnsUsers < ActiveRecord::Migration[5.2]
  def up
    add_column(:users, :name,       :string,  null: false, after: :id)
    add_column(:users, :admin,      :boolean, null: false, default: false, after: :email)
    add_column(:users, :image,      :string,  after: :admin)
    add_column(:users, :deleted_at, :datetime, after: :image)

    change_column(:users, :email, :string, limit: 300)
  end

  def down
    remove_column(:users, :name)
    remove_column(:users, :admin)
    remove_column(:users, :image)
    remove_column(:users, :deleted_at)
  end
end
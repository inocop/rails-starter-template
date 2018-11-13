class AddColumnsUsers < ActiveRecord::Migration[5.1]
  def up
    add_column(:users, :name,       :string,  null: false, :after => :id)
    add_column(:users, :admin,      :boolean, null: false, default: false, :after => :email)
    add_column(:users, :image_path, :string,  :after => :admin)
    add_column(:users, :deleted_at, :datetime, :after => :image_path)

    add_index(:users, [:email, :deleted_at], unique: true)
  end

  def down
    remove_index(:users, [:email, :deleted_at])

    remove_column(:users, :name)
    remove_column(:users, :admin)
    remove_column(:users, :image_path)
    remove_column(:users, :deleted_at)
  end
end
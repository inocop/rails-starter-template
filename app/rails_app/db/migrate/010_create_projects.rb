class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, :null => false
      t.string :summary
      t.date   :start_date
      t.date   :end_date
      t.datetime :deleted_at, default: nil

      t.timestamps
    end
  end
end

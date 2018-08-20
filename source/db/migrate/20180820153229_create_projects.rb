class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.date :start_day
      t.date :end_day

      t.timestamps
    end
  end
end

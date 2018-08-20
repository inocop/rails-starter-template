class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.string :name
      t.integer :work_type
      t.time :work_time
      t.date :work_day
      t.integer :tanto_user_id

      t.timestamps
    end
  end
end

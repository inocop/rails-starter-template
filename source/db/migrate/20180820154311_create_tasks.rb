class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer :project_id,     :null => false
      t.string  :name,           :null => false
      t.integer :work_type
      t.time    :work_time
      t.date    :work_day
      t.integer :tanto_user_id,  :null => false

      t.timestamps
    end
  end
end

class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.string   :name,                null: false
      t.string   :summary
      t.integer  :status,           default: 1
      t.string   :attachment_file
      t.time     :work_time
      t.date     :start_date
      t.date     :end_date
      t.bigint   :project_id,          null: false
      t.bigint   :assigned_user_id,    null: false
      t.datetime :deleted_at,       default: nil

      t.timestamps
    end
  end
end

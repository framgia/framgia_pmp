class CreateTimeLogs < ActiveRecord::Migration
  def change
    create_table :time_logs do |t|
      t.integer :assignee_id
      t.references :sprint, index: true, foregin: true 
      t.integer :work_date
      t.integer :lost_hour
      
      t.timestamps null: false
    end
  end
end

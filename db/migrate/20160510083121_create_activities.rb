class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :product_backlog
      t.references :sprint, index: true, foreign: true
      t.string :subject
      t.string :description
      t.integer :spent_time
      t.integer :estimate
      t.integer :user_id
      t.references :sprint

      t.timestamps null: false
    end
  end
end

class CreateMasterSprints < ActiveRecord::Migration
  def change
    create_table :master_sprints do |t|
      t.integer :day
      t.date :date
      t.references :sprint, index: true, foregin: true
    end
  end
end

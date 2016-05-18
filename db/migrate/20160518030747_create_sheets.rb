class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.string :key
      t.string :cfg

      t.timestamps null: false
    end
  end
end

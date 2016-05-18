class CreateHeaders < ActiveRecord::Migration
  def change
    create_table :headers do |t|
      t.references :sheet, index: true, foreign_key: true
      t.integer :column_id
      t.string :label
      t.integer :width

      t.timestamps null: false
    end
  end
end

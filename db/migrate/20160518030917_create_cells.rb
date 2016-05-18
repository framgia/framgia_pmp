class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.references :sheet, index: true, foreign_key: true
      t.integer :column_id
      t.integer :row_id
      t.string :data
      t.string :style
      t.string :parsed
      t.string :calc

      t.timestamps null: false
    end
  end
end

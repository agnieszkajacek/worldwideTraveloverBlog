class DropSubcategories < ActiveRecord::Migration[5.2]
  def change
    drop_table :subcategories do |t|
      t.references :category, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end

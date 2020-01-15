class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :photos, :category_id
    add_index :posts, :category_id
  end
end

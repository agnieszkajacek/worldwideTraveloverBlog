class AddCoOrdinatesAndSizeToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :crop_x, :integer
    add_column :posts, :crop_y, :integer
    add_column :posts, :crop_width, :integer
    add_column :posts, :crop_height, :integer
  end
end

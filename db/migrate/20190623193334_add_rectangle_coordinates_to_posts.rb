class AddRectangleCoordinatesToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :crop_rectangle_x, :integer
    add_column :posts, :crop_rectangle_y, :integer
    add_column :posts, :crop_rectangle_width, :integer
    add_column :posts, :crop_rectangle_height, :integer
  end
end

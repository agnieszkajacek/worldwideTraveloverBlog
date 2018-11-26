class AddCoOrdinatesAndSizeToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :crop_x, :integer
    add_column :photos, :crop_y, :integer
    add_column :photos, :crop_width, :integer
    add_column :photos, :crop_height, :integer
  end
end

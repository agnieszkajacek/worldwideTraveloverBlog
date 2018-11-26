class AddTagToPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :tag, :string
  end
end

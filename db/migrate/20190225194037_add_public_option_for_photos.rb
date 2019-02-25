class AddPublicOptionForPhotos < ActiveRecord::Migration[5.2]
  def change
    add_column :photos, :public, :boolean, default: true
  end
end

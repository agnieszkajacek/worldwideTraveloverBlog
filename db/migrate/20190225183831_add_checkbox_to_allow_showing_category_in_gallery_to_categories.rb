class AddCheckboxToAllowShowingCategoryInGalleryToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :show_in_gallery, :boolean, default: false
  end
end

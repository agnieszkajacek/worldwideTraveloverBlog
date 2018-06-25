class AddSubcategoryToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :state, :string
    add_column :categories, :town, :string

    rename_column :categories, :name, :country
  end
end

class AddCoverToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :cover_data, :string
  end
end

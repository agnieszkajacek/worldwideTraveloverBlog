class AddCoverToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :cover_data, :string
  end
end

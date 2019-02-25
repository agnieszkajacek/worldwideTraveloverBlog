class UpdateCategories < ActiveRecord::Migration[5.2]
  def change
    Category.all.each do |c|
      c.update(show_in_gallery: true)
    end
  end
end

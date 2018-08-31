class AddPublishedDateAndIntroductionToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :introduction, :string 
    add_column :posts, :published, :date
  end
end

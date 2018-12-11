class RemoveNameAndSourceFromSubscribers < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscribers, :name
    remove_column :subscribers, :source
  end
end

class AddUnsubscribeHashToSubscribers < ActiveRecord::Migration[5.2]
  def change
    add_column :subscribers, :unsubscribe_hash, :string
    add_column :subscribers, :subscription, :boolean, default: true
  end
end

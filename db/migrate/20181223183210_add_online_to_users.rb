class AddOnlineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :online, :integer, default: 0
  end
end

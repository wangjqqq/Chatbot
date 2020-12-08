class AddOnlineToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :online, :integer, default: 0
  end
end

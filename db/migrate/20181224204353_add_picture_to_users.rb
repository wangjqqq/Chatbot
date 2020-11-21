class AddPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :picture, :string, default: "user-icon.png"
  end
end

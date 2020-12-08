class AddPictureToUsers < ActiveRecord::Migration[6.0]
  def change
  add_column :users, :picture, :string, default: "user-icon.png"
  end
end

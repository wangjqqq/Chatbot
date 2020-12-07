class CreateChats < ActiveRecord::Migration[6.0]
  def change
    #drop_table :chats
    create_table :chats do |t|
      t.string :name
      t.string :description
      t.integer :admin_id
      t.timestamps null: false
    end
  end
end

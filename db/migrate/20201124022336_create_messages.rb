class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    # drop_table :messages
    create_table :messages do |t|
      t.text :body
      t.references :user, index: true, foreign_key: true
      t.references :chat, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end

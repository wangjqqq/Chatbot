class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    drop_table :articles
    create_table :articles do |t|
      t.string :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

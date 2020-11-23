class AddLikeToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :like, :integer, default: 0
  end
end

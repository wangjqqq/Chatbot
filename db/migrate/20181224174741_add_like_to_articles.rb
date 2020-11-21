class AddLikeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :like, :integer, default: 0
  end
end

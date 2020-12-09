class ChangeEssayToUsers < ActiveRecord::Migration[6.0]
  def change
  change_column_default :users, :essay, from: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eos,
        adipisci.", to: "写下你的个性签名吧"
  end
end

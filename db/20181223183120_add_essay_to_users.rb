class AddEssayToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :essay, :string, default: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eos,
        adipisci."
  end
end

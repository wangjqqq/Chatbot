class CreateFootsteps < ActiveRecord::Migration[6.0]
  def change
    #drop_table :footsteps
    create_table :footsteps do |t|
      t.integer :user_id
      t.string :content
      t.integer :footstepuser_id

      t.timestamps null: false
    end
  end
end

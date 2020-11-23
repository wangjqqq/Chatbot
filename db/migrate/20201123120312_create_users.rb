class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    #drop_table :users
    create_table :users do |t|
      t.string :name, index: true
      t.string :email, index: true
      t.integer :role
      t.string :password_digest
      t.string :remember_digest
      t.string :sex
      t.string :phonenumber
      t.string :status
      t.timestamps
    end
  end
end

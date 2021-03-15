class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :phone
      t.string :email, null: false

      t.timestamps
    end

    add_index :users, :username
    add_index :users, :email
  end
end

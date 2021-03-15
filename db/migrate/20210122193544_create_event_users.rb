class CreateEventUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :event_users do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.integer :rsvp

      t.timestamps
    end

    add_index :event_users, :event_id
    add_index :event_users, :user_id
    add_index :event_users, [:event_id, :user_id]
  end
end

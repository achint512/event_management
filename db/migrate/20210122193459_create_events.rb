class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.string :description
      t.boolean :is_allday, default: 0, null: false
      t.boolean :is_completed, default: 0, null: false

      t.timestamps
    end

    add_index :events, :start_datetime
    add_index :events, :end_datetime
    add_index :events, [:title, :start_datetime, :end_datetime]
  end
end

class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id
      t.integer :visited_id, null: false
      t.references :review, foreign_key: true
      t.references :manual, foreign_key: true
      t.integer :type, null: false
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end
    add_index :notifications, :visitor_id
    add_index :notifications, :visited_id
  end
end

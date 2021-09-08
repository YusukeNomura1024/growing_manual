class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :user, foreign_key: true, null: false
      t.references :manual, foreign_key: true
      t.references :review, foreign_key: true
      t.text :comment, null: false
      t.integer :type, null: false
      t.boolean :is_replied, null: false, default: false

      t.timestamps
    end
  end
end

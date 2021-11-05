class CreateManuals < ActiveRecord::Migration[5.2]
  def change
    create_table :manuals do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false
      t.string :image_id
      t.text :description
      t.boolean :status, null: false, default: false
      t.datetime :release_date

      t.timestamps
    end
  end
end

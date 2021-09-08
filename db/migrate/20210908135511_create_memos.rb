class CreateMemos < ActiveRecord::Migration[5.2]
  def change
    create_table :memos do |t|
      t.references :user, foreign_key: true, null: false
      t.references :category, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :url
      t.text :code

      t.timestamps
    end
  end
end

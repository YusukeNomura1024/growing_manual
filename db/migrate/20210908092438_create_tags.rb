class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.references :user, foreign_key: true, null: false
      t.string :name

      t.timestamps
    end
  end
end

class CreateBookmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :bookmarks do |t|
      t.references :user, type: :bigint, foreign_key: true, null: false
      t.references :manual, type: :integer, foreign_key: true, null: false

      t.timestamps
    end
  end
end

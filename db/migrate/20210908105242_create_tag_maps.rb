class CreateTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_maps do |t|
      t.references :manual, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false

      t.timestamps
    end
  end
end

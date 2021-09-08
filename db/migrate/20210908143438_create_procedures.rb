class CreateProcedures < ActiveRecord::Migration[5.2]
  def change
    create_table :procedures do |t|
      t.references :manual, foreign_key: true, null: false
      t.string :title, null: false
      t.integer :position, null: false


      t.timestamps
    end
  end
end

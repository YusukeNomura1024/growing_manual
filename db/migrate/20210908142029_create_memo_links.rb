class CreateMemoLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :memo_links do |t|
      t.references :procedure, foreign_key: true, null: false
      t.references :memo, foreign_key: true, null: false

      t.timestamps
    end
  end
end

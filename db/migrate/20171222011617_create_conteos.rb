class CreateConteos < ActiveRecord::Migration[5.1]
  def change
    create_table :conteos do |t|
      t.references :articulo, foreign_key: true
      t.references :corte, foreign_key: true

      t.integer :total, default: 0
    end
  end
end

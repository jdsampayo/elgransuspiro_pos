class CreateDesechables < ActiveRecord::Migration[5.1]
  def change
    create_table :desechables do |t|
      t.string :nombre
      t.integer :en_bodega
      t.integer :cantidad
      t.decimal :costo_unitario

      t.timestamps
    end
  end
end

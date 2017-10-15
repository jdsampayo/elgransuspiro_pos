class CreateOrdenes < ActiveRecord::Migration[5.1]
  def change
    create_table :ordenes do |t|
      t.integer :articulo_id
      t.integer :comanda_id
      t.index :comanda_id
      t.integer :cantidad
      t.decimal :precio_unitario, default: 0

      t.timestamps
    end
  end
end

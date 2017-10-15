class CreateComandas < ActiveRecord::Migration[5.1]
  def change
    create_table :comandas do |t|
      t.decimal :venta, default: 0
      t.decimal :descuento, default: 0
      t.decimal :total, default: 0
      t.integer :mesero_id
      t.index :mesero_id
      t.datetime :deleted_at
      t.index :deleted_at
      t.datetime :closed_at
      t.index :closed_at
      t.integer :comensales, default: 1
      t.string :mesa, default: "PARA LLEVAR"

      t.timestamps
    end
  end
end

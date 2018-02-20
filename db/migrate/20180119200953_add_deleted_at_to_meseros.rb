class AddDeletedAtToMeseros < ActiveRecord::Migration[5.1]
  def change
    add_column :meseros, :deleted_at, :datetime
    add_index :meseros, :deleted_at

    add_column :articulos, :deleted_at, :datetime
    add_index :articulos, :deleted_at

    add_column :conteos, :deleted_at, :datetime
    add_index :conteos, :deleted_at

    add_column :categorias, :deleted_at, :datetime
    add_index :categorias, :deleted_at

    add_column :cortes, :deleted_at, :datetime
    add_index :cortes, :deleted_at

    add_column :desechables, :deleted_at, :datetime
    add_index :desechables, :deleted_at

    add_column :extras, :deleted_at, :datetime
    add_index :extras, :deleted_at

    add_column :extra_ordenes, :deleted_at, :datetime
    add_index :extra_ordenes, :deleted_at

    add_column :gastos, :deleted_at, :datetime
    add_index :gastos, :deleted_at

    add_column :ordenes, :deleted_at, :datetime
    add_index :ordenes, :deleted_at
  end
end

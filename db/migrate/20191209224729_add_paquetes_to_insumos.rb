class AddPaquetesToInsumos < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE insumo_paquete AS ENUM ('caja', 'pieza', 'kilo', 'litro');
    SQL
    add_column :insumos, :paquete, :insumo_paquete
    add_index :insumos, :paquete
  end

  def down
    remove_column :insumos, :paquete
    execute <<-SQL
      DROP TYPE insumo_paquete;
    SQL
  end
end

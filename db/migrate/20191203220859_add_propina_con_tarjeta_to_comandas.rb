class AddPropinaConTarjetaToComandas < ActiveRecord::Migration[6.0]
  def change
    add_column :comandas, :propina_con_tarjeta, :decimal, default: 0
    rename_column :comandas, :propina, :propina_con_efectivo
  end
end

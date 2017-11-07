class AddPagosConTarjetaToCortes < ActiveRecord::Migration[5.1]
  def change
    add_column :cortes, :pagos_con_tarjeta, :decimal, default: 0
    add_column :cortes, :pagos_con_efectivo, :decimal, default: 0
  end
end

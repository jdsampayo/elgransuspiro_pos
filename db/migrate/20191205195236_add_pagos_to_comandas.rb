class AddPagosToComandas < ActiveRecord::Migration[6.0]
  def change
    add_column :comandas, :pago_con_efectivo, :decimal, default: 0
    add_column :comandas, :pago_con_tarjeta, :decimal, default: 0
  end
end

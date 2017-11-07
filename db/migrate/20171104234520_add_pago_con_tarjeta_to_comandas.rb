class AddPagoConTarjetaToComandas < ActiveRecord::Migration[5.1]
  def change
    add_column :comandas, :pago_con_tarjeta, :boolean, default: false
  end
end

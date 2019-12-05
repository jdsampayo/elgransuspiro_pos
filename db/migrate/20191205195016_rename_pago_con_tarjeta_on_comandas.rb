class RenamePagoConTarjetaOnComandas < ActiveRecord::Migration[6.0]
  def change
    rename_column :comandas, :pago_con_tarjeta, :es_pago_con_tarjeta
  end
end

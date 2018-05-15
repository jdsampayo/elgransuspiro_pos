class AddProcentajeDeDescuentoToComandas < ActiveRecord::Migration[5.1]
  def change
    add_column :comandas, :porcentaje_de_descuento, :integer, default: 0
  end
end

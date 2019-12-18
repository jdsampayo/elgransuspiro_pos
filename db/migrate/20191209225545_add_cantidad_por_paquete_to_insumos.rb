class AddCantidadPorPaqueteToInsumos < ActiveRecord::Migration[6.0]
  def change
    add_column :insumos, :cantidad_por_paquete, :integer, default: 0
  end
end

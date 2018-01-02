class AddParaLlevarToOrdenes < ActiveRecord::Migration[5.1]
  def change
    add_column :ordenes, :para_llevar, :boolean
  end
end

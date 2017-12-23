class AddPropinaToComandas < ActiveRecord::Migration[5.1]
  def change
    add_column :comandas, :propina, :decimal, default: 0
  end
end

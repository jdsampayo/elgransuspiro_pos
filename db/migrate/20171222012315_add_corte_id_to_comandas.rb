class AddCorteIdToComandas < ActiveRecord::Migration[5.1]
  def change
    add_column :comandas, :corte_id, :integer
  end
end

class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :cortes, :gastos, :sum_gastos
  end
end

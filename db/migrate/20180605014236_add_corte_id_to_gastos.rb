class AddCorteIdToGastos < ActiveRecord::Migration[5.1]
  def change
    add_reference :gastos, :corte, foreign_key: true, type: :uuid
  end
end

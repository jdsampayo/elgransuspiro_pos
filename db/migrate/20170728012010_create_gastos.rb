class CreateGastos < ActiveRecord::Migration[5.1]
  def change
    create_table :gastos do |t|
      t.decimal :monto, default: 0
      t.string :descripcion

      t.timestamps
    end
  end
end

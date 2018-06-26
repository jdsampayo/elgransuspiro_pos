class CreateInsumos < ActiveRecord::Migration[5.2]
  def change
    create_table :insumos, id: :uuid do |t|
      t.string :nombre
      t.integer :cantidad_actual, default: 0
      t.string :unidad
      t.datetime :deleted_at

      t.timestamps
    end
  end
end

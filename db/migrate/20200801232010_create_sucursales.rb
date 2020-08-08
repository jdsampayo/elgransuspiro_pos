class CreateSucursales < ActiveRecord::Migration[6.0]
  def change
    create_table :sucursales, id: :uuid do |t|
      t.string :nombre
      t.text :direccion
      t.string :telefono

      t.timestamps
    end
  end
end

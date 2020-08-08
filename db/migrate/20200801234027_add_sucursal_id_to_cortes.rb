class AddSucursalIdToCortes < ActiveRecord::Migration[6.0]
  def change
    add_reference :cortes, :sucursal, foreign_key: true, type: :uuid
  end
end

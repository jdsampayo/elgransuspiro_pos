class CreateJoinTableArticuloDesechable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :articulos, :desechables do |t|
      t.index [:articulo_id, :desechable_id]
      t.index [:desechable_id, :articulo_id]
    end
  end
end

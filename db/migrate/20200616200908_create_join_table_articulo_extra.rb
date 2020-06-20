class CreateJoinTableArticuloExtra < ActiveRecord::Migration[6.0]
  def change
    create_join_table :articulos, :extras, column_options: {type: :uuid} do |t|
      t.index [:articulo_id, :extra_id]
      t.index [:extra_id, :articulo_id]
    end
  end
end

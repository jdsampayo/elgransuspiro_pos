class CreateExtraOrdenes < ActiveRecord::Migration[5.1]
  def change
    create_table :extra_ordenes do |t|
      t.references :extra, foreign_key: true
      t.references :orden, foreign_key: true

      t.timestamps
    end
  end
end

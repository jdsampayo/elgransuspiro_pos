class CreateArticulos < ActiveRecord::Migration[5.1]
  def change
    create_table :articulos do |t|
      t.string :nombre
      t.decimal :precio, default: 0

      t.timestamps
    end
  end
end
